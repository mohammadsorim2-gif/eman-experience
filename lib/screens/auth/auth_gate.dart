import 'package:flutter/material.dart';

import '../../core/auth/app_user.dart';
import '../../core/auth/auth_controller.dart';
import 'login_screen.dart';

typedef AuthenticatedBuilder = Widget Function(
  BuildContext context,
  AppUser user,
  Future<void> Function() signOut,
);

class AuthGate extends StatefulWidget {
  const AuthGate({
    required this.languageCode,
    required this.authenticatedBuilder,
    super.key,
  });

  final String languageCode;
  final AuthenticatedBuilder authenticatedBuilder;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AuthController()..addListener(_onAuthChanged);
    _controller.restoreSession();
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onAuthChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = _controller.currentUser;
    if (user == null) {
      return LoginScreen(
        languageCode: widget.languageCode,
        onSignIn: _controller.signIn,
      );
    }

    return widget.authenticatedBuilder(
      context,
      user,
      _controller.signOut,
    );
  }
}
