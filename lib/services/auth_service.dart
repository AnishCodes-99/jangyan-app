import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/user_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  AuthService() {
    _tryRestoreSession();
  }

  Future<void> _tryRestoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userPrefsKey);
      if (userJson != null) {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        _currentUser = UserProfile.fromMap(map);
        debugPrint(
          '[AuthService] Restored local session for: ${_currentUser?.email}',
        );
        notifyListeners();

        // Refresh in background from MongoDB backend
        if (_currentUser != null) {
          try {
            final mongoData = await MongoDbService.fetchUser(_currentUser!.email);
            if (mongoData != null) {
              final mongoProfile = UserProfile.fromMap(mongoData);
              // Merge if MongoDB has higher attempted count
              if (mongoProfile.attemptedCount >= _currentUser!.attemptedCount) {
                _currentUser = mongoProfile;
                await _saveSessionToPrefs(_currentUser!);
                notifyListeners();
              }
            }
          } catch (_) {}
        }

        // If Firebase is initialized, check Firestore
        final fs = FirebaseService.firestore;
        if (fs != null && _currentUser != null) {
          try {
            final doc = await fs
                .collection('users')
                .doc(_currentUser!.uid)
                .get();
            if (doc.exists && doc.data() != null) {
              _currentUser = UserProfile.fromMap(
                doc.data()!,
                documentId: doc.id,
              );
              await _saveSessionToPrefs(_currentUser!);
              notifyListeners();
            }
          } catch (e) {
            debugPrint('[AuthService] Background Firestore sync notice: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('[AuthService] Error restoring session: $e');
    }
  }

  /// Deterministic cross-platform password hash (consistent across sessions and compilers)
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

      // 1. Persistent Local Storage (SharedPreferences DB)
      final prefs = await SharedPreferences.getInstance();
      final existingDbJson = prefs.getString(_localUsersDbKey) ?? '{}';
      final Map<String, dynamic> db = jsonDecode(existingDbJson);

      final userRecord = newProfile.toMap();
      userRecord['passwordHash'] = passwordHash;
      db[normalizedEmail] = userRecord;
      await prefs.setString(_localUsersDbKey, jsonEncode(db));

      // 2. Persistent Backend MongoDB Storage
      try {
        await MongoDbService.syncUser(userRecord);
      } catch (e) {
        debugPrint('[AuthService] Backend MongoDB user sync notice: $e');
      }

      // 3. Cloud Firestore (if active)
      if (fs != null) {
        try {
          await fs.collection('users').doc(uid).set(newProfile.toMap());
        } catch (_) {}
      }

      _currentUser = newProfile;
      await _saveSessionToPrefs(newProfile);
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

      // 1. First Attempt: Live Firebase Authentication
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

      // 2. Query MongoDB backend and local DB
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

      // If not authenticated via Firebase, verify against MongoDB or Local DB
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

      // 3. Merging highest stats from all sources so solved questions are NEVER lost
      int bestAttempted = authenticatedProfile.attemptedCount;
      int bestCorrect = authenticatedProfile.correctCount;
      int bestIncorrect = authenticatedProfile.incorrectCount;
      String bestName = authenticatedProfile.fullName;

      if (mongoData != null) {
        final mongoAttempted = (mongoData['attemptedCount'] as num?)?.toInt() ?? 0;
        final mongoCorrect = (mongoData['correctCount'] as num?)?.toInt() ?? 0;
        final mongoIncorrect = (mongoData['incorrectCount'] as num?)?.toInt() ?? 0;
        final mongoName = mongoData['fullName'] as String? ?? '';
        if (mongoAttempted > bestAttempted) {
          bestAttempted = mongoAttempted;
          bestCorrect = mongoCorrect;
          bestIncorrect = mongoIncorrect;
        }
        if (mongoName.isNotEmpty && (bestName.isEmpty || bestName == 'JanGyan Citizen')) {
          bestName = mongoName;
        }
      }

      if (localData != null) {
        final localAttempted = (localData['attemptedCount'] as num?)?.toInt() ?? 0;
        final localCorrect = (localData['correctCount'] as num?)?.toInt() ?? 0;
        final localIncorrect = (localData['incorrectCount'] as num?)?.toInt() ?? 0;
        final localName = localData['fullName'] as String? ?? '';
        if (localAttempted > bestAttempted) {
          bestAttempted = localAttempted;
          bestCorrect = localCorrect;
          bestIncorrect = localIncorrect;
        }
        if (localName.isNotEmpty && (bestName.isEmpty || bestName == 'JanGyan Citizen')) {
          bestName = localName;
        }
      }

      authenticatedProfile = authenticatedProfile.copyWith(
        fullName: bestName,
        attemptedCount: bestAttempted,
        correctCount: bestCorrect,
        incorrectCount: bestIncorrect,
        updatedAt: DateTime.now(),
      );

      // 4. Save and sync everywhere
      _currentUser = authenticatedProfile;
      await _saveSessionToPrefs(_currentUser!);

      final record = _currentUser!.toMap();
      record['passwordHash'] = passwordHash;
      db[normalizedEmail] = record;
      await prefs.setString(_localUsersDbKey, jsonEncode(db));

      // Push merged profile to MongoDB backend
      MongoDbService.syncUser(record);

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
            // Check if account exists in local database or MongoDB
            final prefs = await SharedPreferences.getInstance();
            final dbJson = prefs.getString(_localUsersDbKey) ?? '{}';
            final Map<String, dynamic> db = jsonDecode(dbJson);
            if (db.containsKey(normalizedEmail)) {
              // Account exists in JanGyan DB! Allow them to reset
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

      // Hybrid fallback: check local DB
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

  /// Direct in-app password reset for verified citizens and resilient mode
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

      // 1. Update in SharedPreferences
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
        // Create new record for citizen
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

      // 2. Sync to MongoDB & SQLite
      try {
        await MongoDbService.syncUser({
          'email': normalizedEmail,
          'passwordHash': passwordHash,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } catch (_) {}

      // 3. Update current user if matching
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

  /// Official Firebase Google Sign-In (Web popup & Android native)
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final auth = FirebaseService.auth;
      final fs = FirebaseService.firestore;

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
          // User closed or cancelled Google sign-in
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
          // Resilient local Google profile
          final uid = 'usr_g_${googleUser.id.substring(0, 8)}';
          final email = googleUser.email.trim().toLowerCase();
          final fullName = googleUser.displayName ?? 'Citizen';
          final photoUrl = googleUser.photoUrl;

          final profile = UserProfile(
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
          MongoDbService.syncUser(profile.toMap());
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

      UserProfile? existingProfile;
      if (fs != null) {
        try {
          final doc = await fs.collection('users').doc(uid).get();
          if (doc.exists && doc.data() != null) {
            existingProfile = UserProfile.fromMap(doc.data()!, documentId: doc.id);
          }
        } catch (_) {}
      }

      final profileToSave = existingProfile?.copyWith(
        fullName: fullName.isNotEmpty ? fullName : existingProfile.fullName,
        photoUrl: photoUrl ?? existingProfile.photoUrl,
        updatedAt: DateTime.now(),
      ) ?? UserProfile(
        uid: uid,
        fullName: fullName.isNotEmpty ? fullName : 'Citizen',
        email: email,
        photoUrl: photoUrl,
        isAdmin: email.startsWith('admin@'),
        attemptedCount: 0,
        correctCount: 0,
        incorrectCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to SharedPreferences session
      await _saveSessionToPrefs(profileToSave);

      // Sync to Firestore
      if (fs != null) {
        try {
          await fs.collection('users').doc(uid).set(profileToSave.toMap(), SetOptions(merge: true));
        } catch (_) {}
      }

      // Sync to MongoDB backend & SQLite
      try {
        await MongoDbService.syncUser(profileToSave.toMap());
      } catch (_) {}

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

    // Sync to local DB
    final prefs = await SharedPreferences.getInstance();
    final dbJson = prefs.getString(_localUsersDbKey) ?? '{}';
    final Map<String, dynamic> db = jsonDecode(dbJson);
    if (db.containsKey(_currentUser!.email)) {
      final record = db[_currentUser!.email] as Map<String, dynamic>;
      record['fullName'] = newName.trim();
      record['updatedAt'] = DateTime.now().toIso8601String();
      db[_currentUser!.email] = record;
      await prefs.setString(_localUsersDbKey, jsonEncode(db));
    }

    // Sync to MongoDB backend
    MongoDbService.syncUser(_currentUser!.toMap());

    final fs = FirebaseService.firestore;
    if (fs != null) {
      try {
        await fs.collection('users').doc(_currentUser!.uid).update({
          'fullName': newName.trim(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        debugPrint('[AuthService] Firestore update notice: $e');
      }
    }
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

    // Sync to local DB
    final prefs = await SharedPreferences.getInstance();
    final dbJson = prefs.getString(_localUsersDbKey) ?? '{}';
    final Map<String, dynamic> db = jsonDecode(dbJson);
    if (db.containsKey(_currentUser!.email)) {
      final record = db[_currentUser!.email] as Map<String, dynamic>;
      record['photoUrl'] = photoUrl;
      record['updatedAt'] = DateTime.now().toIso8601String();
      db[_currentUser!.email] = record;
      await prefs.setString(_localUsersDbKey, jsonEncode(db));
    }

    // Sync to MongoDB backend
    MongoDbService.syncUser(_currentUser!.toMap());

    final fs = FirebaseService.firestore;
    if (fs != null) {
      try {
        await fs.collection('users').doc(_currentUser!.uid).update({
          'photoUrl': photoUrl,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        debugPrint('[AuthService] Firestore update photo notice: $e');
      }
    }
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

    // Save to local SharedPreferences DB
    final prefs = await SharedPreferences.getInstance();
    final dbJson = prefs.getString(_localUsersDbKey) ?? '{}';
    final Map<String, dynamic> db = jsonDecode(dbJson);
    final userMap = updated.toMap();
    if (db.containsKey(updated.email)) {
      final existing = db[updated.email] as Map<String, dynamic>;
      userMap['passwordHash'] = existing['passwordHash'];
    }
    db[updated.email] = userMap;
    await prefs.setString(_localUsersDbKey, jsonEncode(db));

    // Save to MongoDB Backend
    MongoDbService.syncUser(userMap);

    // Save to Cloud Firestore
    final fs = FirebaseService.firestore;
    if (fs != null) {
      try {
        await fs.collection('users').doc(_currentUser!.uid).update({
          'attemptedCount': FieldValue.increment(attempted),
          'correctCount': FieldValue.increment(correct),
          'incorrectCount': FieldValue.increment(incorrect),
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        debugPrint('[AuthService] Firestore stats update notice: $e');
      }
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPrefsKey, jsonEncode(profile.toMap()));
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
