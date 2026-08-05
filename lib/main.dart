import 'package:flutter/material.dart';

import 'core/firebase_bootstrap.dart';
import 'erp_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseReady = await FirebaseBootstrap.initialize();
  runApp(EmanErpApp(firebaseReady: firebaseReady));
}
