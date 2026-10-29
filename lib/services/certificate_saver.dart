import 'dart:convert';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'downloader/certificate_downloader.dart';
import 'firebase_service.dart';

class CertificateSaver {
  /// Saves the rendered PNG certificate directly to device storage or browser Downloads.
  /// Returns the saved absolute file path on mobile/desktop, or the filename on Web.
  static Future<String?> saveCertificate({
    required Uint8List pngBytes,
    required String title,
    String? serialNumber,
  }) async {
    final sanitizedTitle = title.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final suffix = serialNumber != null
        ? serialNumber.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
        : '${DateTime.now().millisecondsSinceEpoch}';
    final filename = 'JanGyan_Certificate_${sanitizedTitle}_$suffix.png';

    try {
      final savedResult = await downloadCertificateFile(
        bytes: pngBytes,
        filename: filename,
      );
      return savedResult;
    } catch (e) {
      debugPrint('[CertificateSaver] Error saving certificate: $e');
      return null;
    }
  }

  /// Opens the system share sheet with the rendered Certificate PNG.
  static Future<void> shareCertificate({
    required Uint8List pngBytes,
    required String title,
    String? serialNumber,
  }) async {
    final sanitizedTitle = title.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final suffix = serialNumber != null
        ? serialNumber.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
        : '${DateTime.now().millisecondsSinceEpoch}';
    final filename = 'JanGyan_Certificate_${sanitizedTitle}_$suffix.png';

    if (kIsWeb) {
      // On web, direct download triggers immediately
      await downloadCertificateFile(bytes: pngBytes, filename: filename);
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final file = io.File('${tempDir.path}/$filename');
      await file.writeAsBytes(pngBytes, flush: true);
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png', name: filename)],
        text:
            'I proudly earned the JanGyan Official Citizen Certificate in $title! 🇮🇳 Serial No: ${serialNumber ?? "Verified"} • Check your civic literacy on JanGyan.',
      );
    } catch (e) {
      debugPrint('[CertificateSaver] Error sharing certificate: $e');
    }
  }

  /// Records certificate holder in Cloud Firestore under 'certificates' collection
  /// and local cache in SharedPreferences so it is accessible offline and in Admin panel.
  static Future<void> recordCertificate({
    required String serialNumber,
    required String citizenName,
    required String citizenEmail,
    required String categoryTitle,
    required String categoryId,
    required int score,
    required int totalQuestions,
    required double accuracy,
    required String attemptId,
  }) async {
    try {
      final certData = {
        'serialNumber': serialNumber,
        'citizenName': citizenName,
        'citizenEmail': citizenEmail,
        'categoryTitle': categoryTitle,
        'categoryId': categoryId,
        'score': score,
        'totalQuestions': totalQuestions,
        'accuracy': accuracy,
        'attemptId': attemptId,
        'issuedAt': DateTime.now().toIso8601String(),
        'timestamp': FieldValue.serverTimestamp(),
      };

      // 1. Cloud Firestore persistence (dedicated 'certificates' collection)
      final fs = FirebaseService.firestore;
      if (fs != null) {
        await fs.collection('certificates').doc(serialNumber).set(
              certData,
              SetOptions(merge: true),
            );
        debugPrint('[CertificateSaver] Saved certificate holder to Firestore: $serialNumber ($citizenEmail)');
      }

      // 2. Local SharedPreferences persistence
      final prefs = await SharedPreferences.getInstance();
      const localKey = 'jangyan_certificates_database';
      final existing = prefs.getStringList(localKey) ?? [];
      final encoded = jsonEncode({
        ...certData,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Avoid duplicates
      final isDuplicate = existing.any((item) {
        try {
          final decoded = jsonDecode(item) as Map<String, dynamic>;
          return decoded['serialNumber'] == serialNumber;
        } catch (_) {
          return false;
        }
      });

      if (!isDuplicate) {
        existing.insert(0, encoded);
        if (existing.length > 200) existing.removeLast();
        await prefs.setStringList(localKey, existing);
      }
    } catch (e) {
      debugPrint('[CertificateSaver] Notice saving certificate: $e');
    }
  }

  /// Retrieves certificate holders list from Cloud Firestore, falling back to local storage
  static Future<List<Map<String, dynamic>>> getCertificateHolders() async {
    final List<Map<String, dynamic>> results = [];
    final Set<String> seenSerials = {};

    // 1. Fetch from Cloud Firestore if available
    final fs = FirebaseService.firestore;
    if (fs != null) {
      try {
        final snapshot = await fs
            .collection('certificates')
            .orderBy('issuedAt', descending: true)
            .limit(100)
            .get();
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final serial = data['serialNumber'] as String? ?? doc.id;
          if (seenSerials.add(serial)) {
            results.add(data);
          }
        }
      } catch (e) {
        debugPrint('[CertificateSaver] Firestore fetch notice: $e');
      }
    }

    // 2. Merge local records
    try {
      final prefs = await SharedPreferences.getInstance();
      const localKey = 'jangyan_certificates_database';
      final existing = prefs.getStringList(localKey) ?? [];
      for (var item in existing) {
        try {
          final map = jsonDecode(item) as Map<String, dynamic>;
          final serial = map['serialNumber'] as String? ?? '';
          if (serial.isNotEmpty && seenSerials.add(serial)) {
            results.add(map);
          }
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('[CertificateSaver] Local fetch error: $e');
    }

    return results;
  }

  /// Retrieves certificates specifically for the current citizen (by email or name),
  /// merging Cloud Firestore and local device records.
  static Future<List<Map<String, dynamic>>> getUserCertificates({
    String? userEmail,
    String? userName,
  }) async {
    final List<Map<String, dynamic>> results = [];
    final Set<String> seenSerials = {};

    final cleanEmail = (userEmail ?? '').toLowerCase().trim();
    final cleanName = (userName ?? '').toLowerCase().trim();

    // 1. Fetch from Cloud Firestore
    final fs = FirebaseService.firestore;
    if (fs != null) {
      try {
        final snapshot = await fs
            .collection('certificates')
            .orderBy('issuedAt', descending: true)
            .get();
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final serial = data['serialNumber'] as String? ?? doc.id;
          final certEmail = (data['citizenEmail'] as String? ?? '').toLowerCase().trim();
          final certName = (data['citizenName'] as String? ?? '').toLowerCase().trim();

          final matchEmail = cleanEmail.isNotEmpty && certEmail.isNotEmpty && certEmail == cleanEmail;
          final matchName = cleanName.isNotEmpty && certName.isNotEmpty && certName == cleanName;

          if ((matchEmail || matchName) && seenSerials.add(serial)) {
            results.add(data);
          }
        }
      } catch (e) {
        debugPrint('[CertificateSaver] Firestore user certs notice: $e');
      }
    }

    // 2. Merge local records
    try {
      final prefs = await SharedPreferences.getInstance();
      const localKey = 'jangyan_certificates_database';
      final existing = prefs.getStringList(localKey) ?? [];
      for (var item in existing) {
        try {
          final map = jsonDecode(item) as Map<String, dynamic>;
          final serial = map['serialNumber'] as String? ?? '';
          final certEmail = (map['citizenEmail'] as String? ?? '').toLowerCase().trim();
          final certName = (map['citizenName'] as String? ?? '').toLowerCase().trim();

          final matchEmail = cleanEmail.isNotEmpty && certEmail.isNotEmpty && certEmail == cleanEmail;
          final matchName = cleanName.isNotEmpty && certName.isNotEmpty && certName == cleanName;

          if (serial.isNotEmpty && (matchEmail || matchName || (cleanEmail.isEmpty && cleanName.isEmpty))) {
            if (seenSerials.add(serial)) {
              results.add(map);
            }
          }
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('[CertificateSaver] Local user certs notice: $e');
    }

    // 3. Fallback: Automatically extract qualifying attempts (accuracy >= 70%) if none found in cert DB
    if (results.isEmpty) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final history = prefs.getStringList('jangyan_attempts_history') ?? [];
        for (var item in history) {
          try {
            final map = jsonDecode(item) as Map<String, dynamic>;
            final accuracy = (map['accuracy'] as num?)?.toDouble() ?? 0.0;
            if (accuracy >= 70.0) {
              final attemptId = map['attemptId'] as String? ?? '';
              final rawId = attemptId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
              final shortId = rawId.length >= 8
                  ? rawId.substring(0, 8).toUpperCase()
                  : 'CERT${DateTime.now().millisecondsSinceEpoch % 1000000}';
              final year = DateTime.now().year;
              final serial = 'JGYN-$year-$shortId';

              if (seenSerials.add(serial)) {
                results.add({
                  'serialNumber': serial,
                  'citizenName': userName ?? 'Citizen',
                  'citizenEmail': userEmail ?? '',
                  'categoryTitle': map['categoryTitle'] ?? 'Civic Literacy',
                  'categoryId': map['categoryId'] ?? 'civic_literacy',
                  'score': map['score'] ?? 0,
                  'totalQuestions': map['totalQuestions'] ?? 20,
                  'accuracy': accuracy,
                  'attemptId': attemptId,
                  'issuedAt': map['timestamp'] ?? DateTime.now().toIso8601String(),
                });
              }
            }
          } catch (_) {}
        }
      } catch (_) {}
    }

    return results;
  }
}

