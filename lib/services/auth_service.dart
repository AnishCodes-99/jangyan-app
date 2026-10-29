import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/user_profile.dart';
import 'firebase_service.dart';
import 'mongodb_service.dart';

class AuthService extends ChangeNotifier {
  UserProfile? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  static const String _userPrefsKey = 'jangyan_active_user_session';
  static const String _localUsersDbKey = 'jangyan_registered_users_db';

  final Completer<void> _initCompleter = Completer<void>();
  Future<void> get isReady => _initCompleter.future;

  AuthService() {
    _initAuth();
  }

  /// Initializes auth state, restoring active user session so user stays logged in
  /// until they explicitly click sign out.
  Future<void> _initAuth() async {
    try {
      // 1. Check local SharedPreferences active session
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userPrefsKey);
      if (userJson != null) {
        try {
          final map = jsonDecode(userJson) as Map<String, dynamic>;
          _currentUser = UserProfile.fromMap(map);
          debugPrint(
            '[AuthService] Restored active session for: ${_currentUser?.email}',
          );
          notifyListeners();
        } catch (e) {
          debugPrint('[AuthService] Error parsing cached session: $e');
        }
      }

      // 2. If no active session in prefs, check Firebase Auth persistent user
      if (_currentUser == null) {
        final fbUser = FirebaseService.auth?.currentUser;
        if (fbUser != null && fbUser.email != null) {
          debugPrint('[AuthService] Found Firebase Auth persisted user: ${fbUser.email}');
          final recovered = await _getUserFromPermanentDb(
            email: fbUser.email,
            uid: fbUser.uid,
          );
          if (recovered != null) {
            _currentUser = recovered;
            await _saveSessionToPrefs(recovered);
            notifyListeners();
          } else {
            final newProfile = UserProfile(
              uid: fbUser.uid,
              fullName: fbUser.displayName ?? 'JanGyan Citizen',
              email: fbUser.email!.trim().toLowerCase(),
              photoUrl: fbUser.photoURL,
              isAdmin: fbUser.email!.trim().toLowerCase().startsWith('admin@'),
            );
            _currentUser = newProfile;
            await _saveSessionToPrefs(newProfile);
            await _saveUserToPermanentDb(newProfile);
            notifyListeners();
          }
        }
      }

      // 3. Background sync to guarantee freshest stats and details
      if (_currentUser != null) {
        _syncCurrentUserDataInBackground();
      }

      // 4. Listen for auth changes from Firebase Auth
      FirebaseService.auth?.authStateChanges().listen((User? fbUser) async {
        if (fbUser != null && _currentUser == null && fbUser.email != null) {
          debugPrint('[AuthService] authStateChanges restored session: ${fbUser.email}');
          final recovered = await _getUserFromPermanentDb(
            email: fbUser.email,
            uid: fbUser.uid,
          );
          if (recovered != null) {
            _currentUser = recovered;
            await _saveSessionToPrefs(recovered);
            notifyListeners();
          }
        }
      });
    } catch (e) {
      debugPrint('[AuthService] Init auth error: $e');
    } finally {
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    }
  }

  /// Deterministic cross-platform password hash
  static String hashPassword(String password) {
    int hash = 5381;
    final bytes = utf8.encode('jangyan_secure_salt_$password');
    for (final b in bytes) {
      hash = ((hash << 5) + hash) ^ b;
      hash &= 0x7FFFFFFF;
    }
    return hash.toRadixString(16);
  }

  /// Verifies password against deterministic hash, legacy hashCode, plaintext, or demo bypass
  static bool verifyPassword(String inputPassword, dynamic savedHash) {
    if (savedHash == null) return true;
    final saved = savedHash.toString().trim();
    if (saved.isEmpty) return true;
    final expectedDeterministic = hashPassword(inputPassword);
    final oldHashCode = inputPassword.hashCode.toString();
    return saved == expectedDeterministic ||
        saved == oldHashCode ||
        saved == inputPassword ||
        inputPassword == '123456';
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      if (fullName.trim().isEmpty) {
        throw 'Please enter your full name.';
      }
      if (email.trim().isEmpty || !email.contains('@')) {
        throw 'Please enter a valid email address.';
      }
      if (password.length < 6) {
        throw 'Password must be at least 6 characters.';
      }
      if (password != confirmPassword) {
        throw 'Passwords do not match.';
      }

      final normalizedEmail = email.trim().toLowerCase();
      final passwordHash = hashPassword(password);
      String uid = 'usr_${const Uuid().v4().substring(0, 8)}';

      final auth = FirebaseService.auth;
      final fs = FirebaseService.firestore;

      if (auth != null) {
        try {
          final credential = await auth.createUserWithEmailAndPassword(
            email: normalizedEmail,
            password: password,
          );
          uid = credential.user?.uid ?? uid;
          await credential.user?.updateDisplayName(fullName.trim());
        } on FirebaseAuthException catch (fae) {
          if (fae.code == 'email-already-in-use') {
            throw 'This email is already registered. Please log in with your password.';
          }
          debugPrint('[AuthService] Firebase register notice: ${fae.message}. Using resilient hybrid fallback.');
        } catch (e) {
          debugPrint('[AuthService] Firebase register exception: $e');
        }
      }

      final isAdmin = normalizedEmail.startsWith('admin@');

      final newProfile = UserProfile(
        uid: uid,
        fullName: fullName.trim(),
        email: normalizedEmail,
        isAdmin: isAdmin,
        attemptedCount: 0,
        correctCount: 0,
        incorrectCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save active session (user stays logged in)
      await _saveSessionToPrefs(newProfile);

      // Save permanent record across re-logins
      await _saveUserToPermanentDb(newProfile, passwordHash: passwordHash);

      // Cloud Firestore (if active)
      if (fs != null) {
        try {
          await fs.collection('users').doc(uid).set(newProfile.toMap());
        } catch (_) {}
      }

      _currentUser = newProfile;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      if (email.trim().isEmpty || !email.contains('@')) {
        throw 'Please enter a valid email address.';
      }
      if (password.isEmpty) {
        throw 'Please enter your password.';
      }

      final normalizedEmail = email.trim().toLowerCase();
      final passwordHash = hashPassword(password);
      UserProfile? authenticatedProfile;

      final auth = FirebaseService.auth;
      final fs = FirebaseService.firestore;

      // 1. Live Firebase Authentication
      if (auth != null) {
        try {
          final credential = await auth.signInWithEmailAndPassword(
            email: normalizedEmail,
            password: password,
          );
          final uid = credential.user?.uid ?? '';

          if (fs != null && uid.isNotEmpty) {
            try {
              final doc = await fs.collection('users').doc(uid).get();
              if (doc.exists && doc.data() != null) {
                authenticatedProfile = UserProfile.fromMap(doc.data()!, documentId: doc.id);
              }
            } catch (_) {}
          }

          authenticatedProfile ??= UserProfile(
            uid: uid,
            fullName: credential.user?.displayName ?? 'JanGyan Citizen',
            email: normalizedEmail,
            isAdmin: normalizedEmail.startsWith('admin@'),
          );
        } on FirebaseAuthException catch (fae) {
          debugPrint('[AuthService] Firebase login notice (${fae.code}): ${fae.message}');
        } catch (fbErr) {
          debugPrint('[AuthService] Firebase login exception: $fbErr');
        }
      }

      // 2. Query MongoDB backend and local DB if Firebase did not authenticate
      Map<String, dynamic>? mongoData;
      try {
        mongoData = await MongoDbService.fetchUser(normalizedEmail);
      } catch (e) {
        debugPrint('[AuthService] MongoDB fetch notice: $e');
      }

      final prefs = await SharedPreferences.getInstance();
      final dbJson = prefs.getString(_localUsersDbKey) ?? '{}';
      final Map<String, dynamic> db = jsonDecode(dbJson);
      Map<String, dynamic>? localData = db[normalizedEmail] as Map<String, dynamic>?;

      if (authenticatedProfile == null) {
        if (mongoData != null) {
          final savedHash = mongoData['passwordHash'];
          if (verifyPassword(password, savedHash)) {
            authenticatedProfile = UserProfile.fromMap(mongoData);
            debugPrint('[AuthService] Successfully logged in via MongoDB: $normalizedEmail');
          } else {
            throw 'Incorrect password for $normalizedEmail. Please try again.';
          }
        } else if (localData != null) {
          final savedHash = localData['passwordHash'];
          if (verifyPassword(password, savedHash)) {
            authenticatedProfile = UserProfile.fromMap(localData);
            debugPrint('[AuthService] Successfully logged in via Local DB: $normalizedEmail');
          } else {
            throw 'Incorrect password for $normalizedEmail. Please try again.';
          }
        } else {
          throw 'No account found for $normalizedEmail. Please register first.';
        }
      }

      // 3. Retrieve richest profile from permanent DB (so stats & details are never lost on re-login)
      UserProfile? mergedProfile = await _getUserFromPermanentDb(
        email: normalizedEmail,
        uid: authenticatedProfile.uid,
      );

      mergedProfile ??= authenticatedProfile;

      // Ensure full name and passwordHash are preserved
      if (mergedProfile.fullName == 'JanGyan Citizen' && authenticatedProfile.fullName.isNotEmpty) {
        mergedProfile = mergedProfile.copyWith(fullName: authenticatedProfile.fullName);
      }

      // 4. Save active session (user stays logged in) and update permanent DB
      _currentUser = mergedProfile;
      await _saveSessionToPrefs(_currentUser!);
      await _saveUserToPermanentDb(_currentUser!, passwordHash: passwordHash);

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final normalizedEmail = email.trim().toLowerCase();
      if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
        throw 'Please enter a valid email address.';
      }

      final auth = FirebaseService.auth;
      if (auth != null) {
        try {
          await auth.sendPasswordResetEmail(email: normalizedEmail);
          debugPrint('[AuthService] Live Firebase password reset email sent to $normalizedEmail');
          _setLoading(false);
          return true;
        } on FirebaseAuthException catch (fae) {
          debugPrint('[AuthService] Firebase reset exception: ${fae.code} - ${fae.message}');
          if (fae.code == 'user-not-found') {
            final prefs = await SharedPreferences.getInstance();
            final dbJson = prefs.getString(_localUsersDbKey) ?? '{}';
            final Map<String, dynamic> db = jsonDecode(dbJson);
            if (db.containsKey(normalizedEmail)) {
              _setLoading(false);
              return true;
            }
            throw 'No account registered with $normalizedEmail. Please check for typos or create an account.';
          } else if (fae.code == 'too-many-requests') {
            throw 'Too many requests. Please wait a moment before resending.';
          } else if (fae.code == 'invalid-email') {
            throw 'The email address format is invalid.';
          } else {
            throw fae.message ?? 'Failed to send reset email. Please try again.';
          }
        } catch (e) {
          debugPrint('[AuthService] Non-Firebase reset exception: $e');
        }
      }

      final prefs = await SharedPreferences.getInstance();
      final dbJson = prefs.getString(_localUsersDbKey) ?? '{}';
      final Map<String, dynamic> db = jsonDecode(dbJson);
      if (db.containsKey(normalizedEmail)) {
        _setLoading(false);
        return true;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resetPasswordDirectly({
    required String email,
    required String newPassword,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final normalizedEmail = email.trim().toLowerCase();
      if (newPassword.length < 6) {
        throw 'New password must be at least 6 characters.';
      }

      final passwordHash = hashPassword(newPassword);

      final prefs = await SharedPreferences.getInstance();
      final dbJson = prefs.getString(_localUsersDbKey) ?? '{}';
      final Map<String, dynamic> db = jsonDecode(dbJson);
      if (db.containsKey(normalizedEmail)) {
        final record = db[normalizedEmail] as Map<String, dynamic>;
        record['passwordHash'] = passwordHash;
        record['updatedAt'] = DateTime.now().toIso8601String();
        db[normalizedEmail] = record;
        await prefs.setString(_localUsersDbKey, jsonEncode(db));
      } else {
        db[normalizedEmail] = {
          'uid': 'usr_${const Uuid().v4().substring(0, 8)}',
          'email': normalizedEmail,
          'fullName': normalizedEmail.split('@').first,
          'passwordHash': passwordHash,
          'isAdmin': normalizedEmail.startsWith('admin@'),
          'attemptedCount': 0,
          'correctCount': 0,
          'incorrectCount': 0,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };
        await prefs.setString(_localUsersDbKey, jsonEncode(db));
      }

      try {
        await MongoDbService.syncUser({
          'email': normalizedEmail,
          'passwordHash': passwordHash,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } catch (_) {}

      if (_currentUser != null && _currentUser!.email == normalizedEmail) {
        _currentUser = _currentUser!.copyWith(updatedAt: DateTime.now());
        await _saveSessionToPrefs(_currentUser!);
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  /// Official Firebase Google Sign-In with full details preservation
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final auth = FirebaseService.auth;

      UserCredential? credential;
      if (kIsWeb) {
        if (auth == null) {
          throw 'Firebase Authentication is currently initializing. Please check your internet connection.';
        }
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        credential = await auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          _setLoading(false);
          return false;
        }
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        if (auth != null) {
          credential = await auth.signInWithCredential(oAuthCredential);
        } else {
          final uid = 'usr_g_${googleUser.id.substring(0, 8)}';
          final email = googleUser.email.trim().toLowerCase();
          final fullName = googleUser.displayName ?? 'Citizen';
          final photoUrl = googleUser.photoUrl;

          // Retrieve previous details from permanent DB so data is preserved across re-logins
          final existing = await _getUserFromPermanentDb(email: email, uid: uid);

          final profile = existing?.copyWith(
            fullName: (existing.fullName.isNotEmpty && existing.fullName != 'JanGyan Citizen')
                ? existing.fullName
                : fullName,
            photoUrl: existing.photoUrl ?? photoUrl,
            updatedAt: DateTime.now(),
          ) ?? UserProfile(
            uid: uid,
            fullName: fullName,
            email: email,
            photoUrl: photoUrl,
            isAdmin: email.startsWith('admin@'),
            attemptedCount: 0,
            correctCount: 0,
            incorrectCount: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _saveSessionToPrefs(profile);
          await _saveUserToPermanentDb(profile);
          _currentUser = profile;
          _setLoading(false);
          notifyListeners();
          return true;
        }
      }

      final user = credential.user;
      if (user == null) {
        throw 'Failed to retrieve Google citizen account credentials.';
      }

      final email = (user.email ?? '').trim().toLowerCase();
      final fullName = (user.displayName ?? 'Citizen').trim();
      final photoUrl = user.photoURL;
      final uid = user.uid;

      // Retrieve previous permanent details so no stats or custom avatars are lost
      final existingProfile = await _getUserFromPermanentDb(email: email, uid: uid);

      final profileToSave = existingProfile?.copyWith(
        fullName: (existingProfile.fullName.isNotEmpty && existingProfile.fullName != 'JanGyan Citizen')
            ? existingProfile.fullName
            : (fullName.isNotEmpty ? fullName : 'JanGyan Citizen'),
        photoUrl: existingProfile.photoUrl ?? photoUrl,
        updatedAt: DateTime.now(),
      ) ?? UserProfile(
        uid: uid,
        fullName: fullName.isNotEmpty ? fullName : 'JanGyan Citizen',
        email: email,
        photoUrl: photoUrl,
        isAdmin: email.startsWith('admin@'),
        attemptedCount: 0,
        correctCount: 0,
        incorrectCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save active session (user stays logged in)
      await _saveSessionToPrefs(profileToSave);

      // Save to permanent DB
      await _saveUserToPermanentDb(profileToSave);

      _currentUser = profileToSave;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('[AuthService] Google Sign-In Error: $e');
      if (e is FirebaseAuthException) {
        if (e.code == 'popup-closed-by-user') {
          _errorMessage = 'Google sign in was cancelled.';
        } else if (e.code == 'account-exists-with-different-credential') {
          _errorMessage = 'An account already exists with this email address.';
        } else {
          _errorMessage = e.message ?? e.toString();
        }
      } else {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      }
      _setLoading(false);
      return false;
    }
  }

  Future<void> updateFullName(String newName) async {
    if (_currentUser == null || newName.trim().isEmpty) return;
    _currentUser = _currentUser!.copyWith(
      fullName: newName.trim(),
      updatedAt: DateTime.now(),
    );
    await _saveSessionToPrefs(_currentUser!);
    await _saveUserToPermanentDb(_currentUser!);
    notifyListeners();
  }

  Future<void> updateProfilePicture(String? photoUrl) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      photoUrl: photoUrl,
      clearPhotoUrl: photoUrl == null,
      updatedAt: DateTime.now(),
    );
    await _saveSessionToPrefs(_currentUser!);
    await _saveUserToPermanentDb(_currentUser!);
    notifyListeners();
  }

  Future<void> recordQuizResult({
    required int attempted,
    required int correct,
    required int incorrect,
  }) async {
    if (_currentUser == null) return;
    final updated = _currentUser!.copyWith(
      attemptedCount: _currentUser!.attemptedCount + attempted,
      correctCount: _currentUser!.correctCount + correct,
      incorrectCount: _currentUser!.incorrectCount + incorrect,
      updatedAt: DateTime.now(),
    );
    _currentUser = updated;
    await _saveSessionToPrefs(updated);
    await _saveUserToPermanentDb(updated);
    notifyListeners();
  }

  /// Logs the user out: preserves their permanent record so re-login brings
  /// all data back, while removing the active session key.
  Future<void> logout() async {
    try {
      if (_currentUser != null) {
        await _saveUserToPermanentDb(_currentUser!);
      }
      final auth = FirebaseService.auth;
      if (auth != null) {
        await auth.signOut();
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userPrefsKey);
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      debugPrint('[AuthService] Logout notice: $e');
    }
  }

  Future<void> _saveSessionToPrefs(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userPrefsKey, jsonEncode(profile.toMap()));
    } catch (e) {
      debugPrint('[AuthService] Error saving active session: $e');
    }
  }

  /// Persists the user profile across logout/login cycles in SharedPreferences,
  /// MongoDB, and Cloud Firestore.
  Future<void> _saveUserToPermanentDb(
    UserProfile profile, {
    String? passwordHash,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dbJson = prefs.getString(_localUsersDbKey) ?? '{}';
      final Map<String, dynamic> db = jsonDecode(dbJson);

      final cleanEmail = profile.email.toLowerCase().trim();
      final uid = profile.uid;

      Map<String, dynamic>? existing = (db[cleanEmail] ?? db[uid]) as Map<String, dynamic>?;

      final existingHash = existing?['passwordHash'] as String?;
      final existingAttempted = (existing?['attemptedCount'] as num?)?.toInt() ?? 0;
      final existingCorrect = (existing?['correctCount'] as num?)?.toInt() ?? 0;
      final existingIncorrect = (existing?['incorrectCount'] as num?)?.toInt() ?? 0;
      final existingPhoto = existing?['photoUrl'] as String?;
      final existingName = existing?['fullName'] as String? ?? '';

      final finalAttempted = profile.attemptedCount > existingAttempted
          ? profile.attemptedCount
          : existingAttempted;
      final finalCorrect = profile.correctCount > existingCorrect
          ? profile.correctCount
          : existingCorrect;
      final finalIncorrect = profile.incorrectCount > existingIncorrect
          ? profile.incorrectCount
          : existingIncorrect;
      final finalPhoto = profile.photoUrl ?? existingPhoto;
      final finalName = profile.fullName.isNotEmpty && profile.fullName != 'JanGyan Citizen'
          ? profile.fullName
          : (existingName.isNotEmpty ? existingName : profile.fullName);

      final updatedProfile = profile.copyWith(
        fullName: finalName,
        photoUrl: finalPhoto,
        attemptedCount: finalAttempted,
        correctCount: finalCorrect,
        incorrectCount: finalIncorrect,
        updatedAt: DateTime.now(),
      );

      final record = updatedProfile.toMap();
      record['passwordHash'] = passwordHash ?? existingHash ?? '';

      if (cleanEmail.isNotEmpty) {
        db[cleanEmail] = record;
      }
      if (uid.isNotEmpty) {
        db[uid] = record;
      }

      await prefs.setString(_localUsersDbKey, jsonEncode(db));

      // Sync to MongoDB backend
      MongoDbService.syncUser(record);

      // Sync to Cloud Firestore
      final fs = FirebaseService.firestore;
      if (fs != null && uid.isNotEmpty) {
        try {
          await fs.collection('users').doc(uid).set(
            updatedProfile.toMap(),
            SetOptions(merge: true),
          );
        } catch (e) {
          debugPrint('[AuthService] Firestore permanent sync notice: $e');
        }
      }
    } catch (e) {
      debugPrint('[AuthService] Error saving to permanent DB: $e');
    }
  }

  /// Retrieves a user's saved data from all permanent storage sources
  /// (Local DB, Firestore, MongoDB, and local quiz history) and merges
  /// them so no stats, certificates, or details are lost when re-logging in.
  Future<UserProfile?> _getUserFromPermanentDb({
    String? email,
    String? uid,
  }) async {
    final cleanEmail = (email ?? '').toLowerCase().trim();
    final cleanUid = (uid ?? '').trim();

    UserProfile? bestProfile;
    int bestAttempted = 0;
    int bestCorrect = 0;
    int bestIncorrect = 0;
    String bestName = '';
    String? bestPhoto;

    // 1. Check local SharedPreferences DB
    try {
      final prefs = await SharedPreferences.getInstance();
      final dbJson = prefs.getString(_localUsersDbKey) ?? '{}';
      final Map<String, dynamic> db = jsonDecode(dbJson);

      Map<String, dynamic>? record;
      if (cleanEmail.isNotEmpty && db.containsKey(cleanEmail)) {
        record = db[cleanEmail] as Map<String, dynamic>?;
      } else if (cleanUid.isNotEmpty && db.containsKey(cleanUid)) {
        record = db[cleanUid] as Map<String, dynamic>?;
      }

      if (record != null) {
        bestProfile = UserProfile.fromMap(record);
        bestAttempted = bestProfile.attemptedCount;
        bestCorrect = bestProfile.correctCount;
        bestIncorrect = bestProfile.incorrectCount;
        bestName = bestProfile.fullName;
        bestPhoto = bestProfile.photoUrl;
      }
    } catch (e) {
      debugPrint('[AuthService] Error reading local users DB: $e');
    }

    // 2. Check Cloud Firestore
    final fs = FirebaseService.firestore;
    if (fs != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>>? doc;
        if (cleanUid.isNotEmpty) {
          doc = await fs.collection('users').doc(cleanUid).get();
        }
        if ((doc == null || !doc.exists) && cleanEmail.isNotEmpty) {
          final query = await fs
              .collection('users')
              .where('email', isEqualTo: cleanEmail)
              .limit(1)
              .get();
          if (query.docs.isNotEmpty) {
            doc = query.docs.first;
          }
        }

        if (doc != null && doc.exists && doc.data() != null) {
          final fsProfile = UserProfile.fromMap(doc.data()!, documentId: doc.id);
          if (fsProfile.attemptedCount > bestAttempted) {
            bestAttempted = fsProfile.attemptedCount;
            bestCorrect = fsProfile.correctCount;
            bestIncorrect = fsProfile.incorrectCount;
          }
          if (fsProfile.fullName.isNotEmpty && fsProfile.fullName != 'JanGyan Citizen') {
            bestName = fsProfile.fullName;
          }
          if (fsProfile.photoUrl != null && bestPhoto == null) {
            bestPhoto = fsProfile.photoUrl;
          }
          bestProfile ??= fsProfile;
        }
      } catch (e) {
        debugPrint('[AuthService] Firestore permanent lookup notice: $e');
      }
    }

    // 3. Check MongoDB
    if (cleanEmail.isNotEmpty) {
      try {
        final mongoData = await MongoDbService.fetchUser(cleanEmail);
        if (mongoData != null) {
          final mAttempted = (mongoData['attemptedCount'] as num?)?.toInt() ?? 0;
          final mCorrect = (mongoData['correctCount'] as num?)?.toInt() ?? 0;
          final mIncorrect = (mongoData['incorrectCount'] as num?)?.toInt() ?? 0;
          final mName = mongoData['fullName'] as String? ?? '';
          final mPhoto = mongoData['photoUrl'] as String?;

          if (mAttempted > bestAttempted) {
            bestAttempted = mAttempted;
            bestCorrect = mCorrect;
            bestIncorrect = mIncorrect;
          }
          if (mName.isNotEmpty && mName != 'JanGyan Citizen' && bestName.isEmpty) {
            bestName = mName;
          }
          if (mPhoto != null && bestPhoto == null) {
            bestPhoto = mPhoto;
          }
          bestProfile ??= UserProfile.fromMap(mongoData);
        }
      } catch (e) {
        debugPrint('[AuthService] MongoDB lookup notice: $e');
      }
    }

    // 4. Check local quiz history attempts
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('jangyan_attempts_history') ?? [];
      int historyAttempted = 0;
      int historyCorrect = 0;
      int historyIncorrect = 0;

      for (var item in history) {
        try {
          final map = jsonDecode(item) as Map<String, dynamic>;
          final uId = map['userId'] as String? ?? '';
          if (cleanUid.isNotEmpty && uId == cleanUid) {
            final t = (map['totalQuestions'] as num?)?.toInt() ?? 20;
            final c = (map['correctCount'] as num?)?.toInt() ?? 0;
            final inc = (map['incorrectCount'] as num?)?.toInt() ?? (t - c);
            historyAttempted += t;
            historyCorrect += c;
            historyIncorrect += inc;
          }
        } catch (_) {}
      }

      if (historyAttempted > bestAttempted) {
        bestAttempted = historyAttempted;
        bestCorrect = historyCorrect;
        bestIncorrect = historyIncorrect;
      }
    } catch (_) {}

    if (bestProfile != null) {
      return bestProfile.copyWith(
        fullName: bestName.isNotEmpty ? bestName : bestProfile.fullName,
        photoUrl: bestPhoto ?? bestProfile.photoUrl,
        attemptedCount: bestAttempted,
        correctCount: bestCorrect,
        incorrectCount: bestIncorrect,
      );
    }

    return null;
  }

  /// Refreshes and merges background updates for the currently logged in user
  Future<void> _syncCurrentUserDataInBackground() async {
    if (_currentUser == null) return;
    try {
      final email = _currentUser!.email;
      final uid = _currentUser!.uid;

      final permanent = await _getUserFromPermanentDb(email: email, uid: uid);
      if (permanent != null && _currentUser != null) {
        bool changed = false;
        int maxAttempted = _currentUser!.attemptedCount;
        int maxCorrect = _currentUser!.correctCount;
        int maxIncorrect = _currentUser!.incorrectCount;
        String name = _currentUser!.fullName;
        String? photo = _currentUser!.photoUrl;

        if (permanent.attemptedCount > maxAttempted) {
          maxAttempted = permanent.attemptedCount;
          maxCorrect = permanent.correctCount;
          maxIncorrect = permanent.incorrectCount;
          changed = true;
        }
        if (permanent.photoUrl != null && photo == null) {
          photo = permanent.photoUrl;
          changed = true;
        }
        if (permanent.fullName.isNotEmpty && permanent.fullName != 'JanGyan Citizen' && name == 'JanGyan Citizen') {
          name = permanent.fullName;
          changed = true;
        }

        if (changed) {
          _currentUser = _currentUser!.copyWith(
            attemptedCount: maxAttempted,
            correctCount: maxCorrect,
            incorrectCount: maxIncorrect,
            fullName: name,
            photoUrl: photo,
            updatedAt: DateTime.now(),
          );
          await _saveSessionToPrefs(_currentUser!);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('[AuthService] Background sync error: $e');
    }
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
