import 'package:flutter/material.dart';

import '../../core/auth/firebase_auth_service.dart';
import '../../core/firebase/firebase_runtime.dart';
import 'firebase_login_screen.dart';

class AppSessionScope extends InheritedWidget {
  const AppSessionScope({
    required this.session,
    required super.child,
    super.key,
  });

  final AppUserSession session;

  static AppUserSession? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppSessionScope>()
        ?.session;
  }

  static AppUserSession of(BuildContext context) {
    final session = maybeOf(context);
    assert(session != null, 'No AppSessionScope found in context.');
    return session!;
  }

  @override
  bool updateShouldNotify(AppSessionScope oldWidget) {
    return session.uid != oldWidget.session.uid ||
        session.role != oldWidget.session.role ||
        session.active != oldWidget.session.active ||
        session.name != oldWidget.session.name ||
        session.email != oldWidget.session.email;
  }
}

class FirebaseAuthGate extends StatefulWidget {
  const FirebaseAuthGate({
    required this.languageCode,
    required this.authenticatedBuilder,
    super.key,
  });

  final String languageCode;
  final Widget Function(AppUserSession session) authenticatedBuilder;

  @override
  State<FirebaseAuthGate> createState() => _FirebaseAuthGateState();
}

class _FirebaseAuthGateState extends State<FirebaseAuthGate> {
  AppUserSession? session;
  bool loading = true;
  String? error;

  String tx(String ar, String tr, String en) => switch (widget.languageCode) {
        'ar' => ar,
        'tr' => tr,
        _ => en,
      };

  @override
  void initState() {
    super.initState();
    restore();
  }

  Future<void> restore() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final restored = await FirebaseAuthService.instance.restoreSession();
      if (!mounted) return;
      setState(() => session = restored);
    } catch (exception) {
      if (!mounted) return;
      setState(() => error = exception.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuthService.instance.signOut();
    if (mounted) setState(() => session = null);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!FirebaseRuntime.configured) {
      return Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 52),
                    const SizedBox(height: 18),
                    Text(
                      tx(
                        'إعدادات Firebase غير موجودة',
                        'Firebase ayarları eksik',
                        'Firebase configuration is missing',
                      ),
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tx(
                        'تعذر تهيئة اتصال Firebase. أعد تحميل التطبيق أو تحقق من إعدادات المشروع.',
                        'Firebase bağlantısı başlatılamadı. Uygulamayı yenileyin veya proje ayarlarını kontrol edin.',
                        'Firebase could not be initialized. Reload the app or check the project configuration.',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (session == null) {
      return FirebaseLoginScreen(
        languageCode: widget.languageCode,
        onSignedIn: (value) => setState(() => session = value),
      );
    }

    final currentSession = session!;
    return AppSessionScope(
      session: currentSession,
      child: _AuthenticatedFrame(
        session: currentSession,
        languageCode: widget.languageCode,
        onSignOut: signOut,
        child: widget.authenticatedBuilder(currentSession),
      ),
    );
  }
}

class _AuthenticatedFrame extends StatelessWidget {
  const _AuthenticatedFrame({
    required this.session,
    required this.languageCode,
    required this.onSignOut,
    required this.child,
  });

  final AppUserSession session;
  final String languageCode;
  final VoidCallback onSignOut;
  final Widget child;

  String tx(String ar, String tr, String en) => switch (languageCode) {
        'ar' => ar,
        'tr' => tr,
        _ => en,
      };

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        PositionedDirectional(
          top: 10,
          end: 12,
          child: SafeArea(
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(18),
              child: PopupMenuButton<String>(
                tooltip: tx('الحساب', 'Hesap', 'Account'),
                onSelected: (value) {
                  if (value == 'logout') onSignOut();
                },
                itemBuilder: (_) => [
                  PopupMenuItem<String>(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(session.name ?? session.email),
                        Text(
                          session.role,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        const Icon(Icons.logout_rounded),
                        const SizedBox(width: 10),
                        Text(tx('تسجيل الخروج', 'Çıkış yap', 'Sign out')),
                      ],
                    ),
                  ),
                ],
                child: CircleAvatar(
                  child: Text(
                    (session.name ?? session.email).trim().isEmpty
                        ? '?'
                        : (session.name ?? session.email)
                            .trim()[0]
                            .toUpperCase(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
