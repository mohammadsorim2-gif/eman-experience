// File generated for the Eman Experience Firebase web application.
// Firebase web configuration values identify the public client application;
// authorization is enforced by Firebase Authentication and security rules.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'Firebase is currently configured for the web platform only. '
          'Run flutterfire configure again when enabling another platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDPgDkRHgEaLArdGXlL9KWjWGS_XhNOuJA',
    appId: '1:373190159239:web:9d6289f010d7630db44122',
    messagingSenderId: '373190159239',
    projectId: 'eman-experience',
    authDomain: 'eman-experience.firebaseapp.com',
    storageBucket: 'eman-experience.firebasestorage.app',
    measurementId: 'G-G7E1ZYTHXG',
  );
}
