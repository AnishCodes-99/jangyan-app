// File generated for JanGyan Firebase project jangyan-e2608
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return web;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAh9-EGQyZaJJ3EoBW-rJ7BKpmFnOuN8aA',
    appId: '1:827728772517:android:e1a861a94cfc5c3697fc4c',
    messagingSenderId: '827728772517',
    projectId: 'jangyan-e2608',
    storageBucket: 'jangyan-e2608.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAQRmMNjfyhAUTMMvMsbJp5pEiTy0iVHTg',
    appId: '1:827728772517:web:adf8753a8793d6cd97fc4c',
    messagingSenderId: '827728772517',
    projectId: 'jangyan-e2608',
    authDomain: 'jangyan-e2608.firebaseapp.com',
    storageBucket: 'jangyan-e2608.firebasestorage.app',
    measurementId: 'G-Q5LWN2G0Q4',
  );
}
