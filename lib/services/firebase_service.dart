import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_options.dart';

class FirebaseService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 8));
      _isInitialized = true;
      debugPrint('[FirebaseService] Live Firebase connected successfully.');
    } catch (e) {
      _isInitialized = false;
      debugPrint('[FirebaseService] Firebase.initializeApp() status: $e');
      debugPrint(
        '[FirebaseService] Operating in resilient mode. Local persistence active.',
      );
    }
  }

  static FirebaseAuth? get auth {
    if (_isInitialized) {
      try {
        return FirebaseAuth.instance;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static FirebaseFirestore? get firestore {
    if (_isInitialized) {
      try {
        return FirebaseFirestore.instance;
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
