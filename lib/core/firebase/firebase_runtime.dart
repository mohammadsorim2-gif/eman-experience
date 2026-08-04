import 'package:firebase_core/firebase_core.dart';

class FirebaseRuntime {
  FirebaseRuntime._();

  static bool _initialized = false;
  static String? _error;

  static bool get initialized => _initialized;
  static String? get error => _error;

  static bool get configured {
    const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_APP_ID');
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
    return apiKey.isNotEmpty && appId.isNotEmpty && projectId.isNotEmpty;
  }

  static Future<bool> initialize() async {
    if (_initialized) return true;
    if (!configured) {
      _error = 'Firebase environment values are missing.';
      return false;
    }

    try {
      const options = FirebaseOptions(
        apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
        appId: String.fromEnvironment('FIREBASE_APP_ID'),
        messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
        authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
        storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
        measurementId: String.fromEnvironment('FIREBASE_MEASUREMENT_ID'),
      );
      await Firebase.initializeApp(options: options);
      _initialized = true;
      _error = null;
      return true;
    } catch (exception) {
      _error = exception.toString();
      return false;
    }
  }
}
