import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

class FirebaseRuntime {
  FirebaseRuntime._();

  static bool _initialized = false;
  static String? _error;

  static bool get initialized => _initialized || Firebase.apps.isNotEmpty;
  static String? get error => _error;
  static bool get configured => true;

  static Future<bool> initialize() async {
    if (initialized) {
      _initialized = true;
      return true;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
      _error = null;
      return true;
    } catch (exception) {
      _error = exception.toString();
      return false;
    }
  }
}
