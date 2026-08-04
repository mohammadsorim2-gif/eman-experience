import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase/firebase_runtime.dart';

class AppUserSession {
  const AppUserSession({
    required this.uid,
    required this.email,
    required this.role,
    required this.active,
    this.name,
  });

  final String uid;
  final String email;
  final String role;
  final bool active;
  final String? name;
}

class FirebaseAuthService {
  FirebaseAuthService._();

  static final instance = FirebaseAuthService._();

  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();

  Future<AppUserSession> signIn({
    required String email,
    required String password,
  }) async {
    final ready = await FirebaseRuntime.initialize();
    if (!ready) {
      throw StateError(FirebaseRuntime.error ?? 'Firebase is not configured.');
    }

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) throw StateError('Authentication returned no user.');
      return _loadSession(user, writeAudit: true);
    } catch (error) {
      if (FirebaseRuntime.initialized) {
        await FirebaseFirestore.instance.collection('loginAudit').add({
          'email': email.trim(),
          'success': false,
          'reason': error.toString(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      rethrow;
    }
  }

  Future<AppUserSession?> restoreSession() async {
    final ready = await FirebaseRuntime.initialize();
    if (!ready) return null;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return _loadSession(user);
  }

  Future<AppUserSession> _loadSession(
    User user, {
    bool writeAudit = false,
  }) async {
    final profile = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = profile.data() ?? const <String, dynamic>{};
    final active = data['active'] != false;
    if (!active) {
      await FirebaseAuth.instance.signOut();
      throw StateError('This account is disabled.');
    }

    if (writeAudit) {
      await FirebaseFirestore.instance.collection('loginAudit').add({
        'uid': user.uid,
        'email': user.email,
        'role': data['role'] ?? 'worker',
        'success': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return AppUserSession(
      uid: user.uid,
      email: user.email ?? '',
      role: (data['role'] as String?) ?? 'worker',
      active: active,
      name: data['name'] as String?,
    );
  }

  Future<void> signOut() async {
    if (!FirebaseRuntime.initialized) return;
    await FirebaseAuth.instance.signOut();
  }
}
