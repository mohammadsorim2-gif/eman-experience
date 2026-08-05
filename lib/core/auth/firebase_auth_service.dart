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

  bool get isOwner => role == 'owner';
  bool get isGeneralManager => role == 'generalManager';
  bool get hasFullAccess => isOwner || isGeneralManager;
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

    final normalizedEmail = email.trim().toLowerCase();
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw StateError('Authentication returned no user.');
      return _loadSession(user, writeAudit: true);
    } catch (error) {
      await _writeAudit(
        email: normalizedEmail,
        success: false,
        reason: _safeReason(error),
      );
      rethrow;
    }
  }

  Future<AppUserSession?> restoreSession() async {
    final ready = await FirebaseRuntime.initialize();
    if (!ready) return null;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      return await _loadSession(user);
    } catch (_) {
      await FirebaseAuth.instance.signOut();
      rethrow;
    }
  }

  Future<AppUserSession> _loadSession(
    User user, {
    bool writeAudit = false,
  }) async {
    final profile = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!profile.exists) {
      await FirebaseAuth.instance.signOut();
      throw StateError('No application profile exists for this account.');
    }

    final data = profile.data() ?? const <String, dynamic>{};
    final enabled = data['enabled'];
    final activeValue = data['active'];
    final active = enabled is bool
        ? enabled
        : activeValue is bool
            ? activeValue
            : true;

    if (!active) {
      await FirebaseAuth.instance.signOut();
      throw StateError('This account is disabled.');
    }

    final roleValue = data['role'];
    final role = roleValue is String && roleValue.trim().isNotEmpty
        ? roleValue.trim()
        : 'worker';
    final nameValue = data['name'];
    final name = nameValue is String && nameValue.trim().isNotEmpty
        ? nameValue.trim()
        : null;

    if (writeAudit) {
      await _writeAudit(
        uid: user.uid,
        email: user.email ?? '',
        role: role,
        success: true,
      );
    }

    return AppUserSession(
      uid: user.uid,
      email: user.email ?? '',
      role: role,
      active: active,
      name: name,
    );
  }

  Future<void> _writeAudit({
    String? uid,
    required String email,
    String? role,
    required bool success,
    String? reason,
  }) async {
    if (!FirebaseRuntime.initialized) return;
    try {
      await FirebaseFirestore.instance.collection('loginAudit').add({
        if (uid != null) 'uid': uid,
        'email': email,
        if (role != null) 'role': role,
        'success': success,
        if (reason != null) 'reason': reason,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Authentication must not fail only because audit logging is unavailable.
    }
  }

  String _safeReason(Object error) {
    if (error is FirebaseAuthException) return error.code;
    if (error is StateError) return error.message.toString();
    return error.runtimeType.toString();
  }

  Future<void> signOut() async {
    if (!FirebaseRuntime.initialized) return;
    await FirebaseAuth.instance.signOut();
  }
}
