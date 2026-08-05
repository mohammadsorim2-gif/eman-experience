import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static const _apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const _appId = String.fromEnvironment('FIREBASE_APP_ID');
  static const _messagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
  static const _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const _authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
  static const _storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
  static const _measurementId = String.fromEnvironment('FIREBASE_MEASUREMENT_ID');

  static bool get isConfigured =>
      _apiKey.isNotEmpty &&
      _appId.isNotEmpty &&
      _messagingSenderId.isNotEmpty &&
      _projectId.isNotEmpty;

  static Future<bool> initialize() async {
    if (Firebase.apps.isNotEmpty) return true;

    try {
      if (kIsWeb) {
        if (!isConfigured) return false;
        await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: _apiKey,
            appId: _appId,
            messagingSenderId: _messagingSenderId,
            projectId: _projectId,
            authDomain: _authDomain.isEmpty ? null : _authDomain,
            storageBucket: _storageBucket.isEmpty ? null : _storageBucket,
            measurementId: _measurementId.isEmpty ? null : _measurementId,
          ),
        );
      } else {
        await Firebase.initializeApp();
      }
      return true;
    } catch (error, stackTrace) {
      debugPrint('Firebase initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }
}
