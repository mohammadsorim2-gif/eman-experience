import 'package:flutter/material.dart';

import 'core/firebase_bootstrap.dart';
import 'enterprise_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.initialize();
  runApp(const EmanEnterpriseApp());
}
