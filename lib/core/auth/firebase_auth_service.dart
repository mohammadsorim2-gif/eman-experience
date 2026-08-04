import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase/firebase_runtime.dart';

class AppUserSession {
  const AppUserSession({required this.uid, required this.email, required this.role, required this.active});

  final String uid;
  final String email;
  final String role;
  final bool active;
}

class FirebaseAuthService {
  FirebaseAuthService._();

  static final instance = FirebaseAuthService._();

  Future<AppUserSession> signIn({required String email, required String password}) async {
    final ready = await FirebaseRuntime.initialize();
    if (!ready) {
      throw StateError(FirebaseRuntime.error ?? 'Firebase is not configured.');
    }

    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) throw StateError('Authentication returned no user.');

    final profile = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = profile.data() ?? const <String, dynamic>{};
    final active = data['active'] != false;
    if (!active) {
      await FirebaseAuth.instance.signOut();
      throw StateError('This account is disabled.');
    }

    await FirebaseFirestore.instance.collection('loginAudit').add({
      'uid': user.uid,
      'email': user.email,
      'success': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return AppUserSession(
      uid: user.uid,
      email: user.email ?? email.trim(),
      role: (data['role'] as String?) ?? 'worker',
      active: active,
    );
  }

  Future<void> signOut() async {
    if (!FirebaseRuntime.initialized) return;
    await FirebaseAuth.instance.signOut();
  }
}
