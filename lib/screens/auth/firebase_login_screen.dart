import 'package:flutter/material.dart';

import '../../core/auth/firebase_auth_service.dart';
import '../../core/firebase/firebase_runtime.dart';

class FirebaseLoginScreen extends StatefulWidget {
  const FirebaseLoginScreen({
    required this.languageCode,
    this.onSignedIn,
    super.key,
  });

  final String languageCode;
  final ValueChanged<AppUserSession>? onSignedIn;

  @override
  State<FirebaseLoginScreen> createState() => _FirebaseLoginScreenState();
}

class _FirebaseLoginScreenState extends State<FirebaseLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  bool obscurePassword = true;
  String? message;

  String tx(String ar, String tr, String en) => switch (widget.languageCode) {
        'ar' => ar,
        'tr' => tr,
        _ => en,
      };

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
      setState(() => message = tx(
            'أدخل البريد وكلمة المرور',
            'E-posta ve şifreyi girin',
            'Enter email and password',
          ));
      return;
    }

    setState(() {
      loading = true;
      message = null;
    });
    try {
      final result = await FirebaseAuthService.instance.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      if (!mounted) return;
      widget.onSignedIn?.call(result);
      if (widget.onSignedIn == null) {
        setState(() => message = tx(
              'تم تسجيل الدخول بنجاح',
              'Giriş başarılı',
              'Signed in successfully',
            ));
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => message = error.toString().replaceFirst('StateError: ', ''));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/logos/Eman logo.png',
                          height: 72,
                          errorBuilder: (_, _, _) => const Icon(Icons.factory_rounded, size: 60),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        tx('تسجيل الدخول إلى EMAN ONE', 'EMAN ONE girişi', 'Sign in to EMAN ONE'),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(tx(
                        'أدخل حساب العمل للوصول إلى نظام إدارة المعمل.',
                        'Fabrika yönetim sistemine erişmek için iş hesabınızı girin.',
                        'Use your work account to access the factory management system.',
                      )),
                      const SizedBox(height: 24),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        decoration: InputDecoration(
                          labelText: tx('البريد الإلكتروني', 'E-posta', 'Email'),
                          prefixIcon: const Icon(Icons.alternate_email_rounded),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        autofillHints: const [AutofillHints.password],
                        onSubmitted: (_) => login(),
                        decoration: InputDecoration(
                          labelText: tx('كلمة المرور', 'Şifre', 'Password'),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => obscurePassword = !obscurePassword),
                            icon: Icon(obscurePassword ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: loading || !FirebaseRuntime.configured ? null : login,
                          icon: loading
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.login_rounded),
                          label: Text(tx('تسجيل الدخول', 'Giriş yap', 'Sign in')),
                        ),
                      ),
                      if (message != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          message!,
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
