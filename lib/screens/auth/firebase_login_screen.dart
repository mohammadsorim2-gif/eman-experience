import 'package:flutter/material.dart';

import '../../core/auth/firebase_auth_service.dart';
import '../../core/firebase/firebase_runtime.dart';

class FirebaseLoginScreen extends StatefulWidget {
  const FirebaseLoginScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<FirebaseLoginScreen> createState() => _FirebaseLoginScreenState();
}

class _FirebaseLoginScreenState extends State<FirebaseLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  AppUserSession? session;
  String? message;

  String tx(String ar, String tr, String en) => switch (widget.languageCode) {
        'ar' => ar,
        'tr' => tr,
        _ => en,
      };

  Future<void> login() async {
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
      setState(() {
        session = result;
        message = tx('تم تسجيل الدخول بنجاح', 'Giriş başarılı', 'Signed in successfully');
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => message = error.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tx('تسجيل الدخول الحقيقي', 'Gerçek giriş', 'Real sign in'))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(FirebaseRuntime.configured ? Icons.cloud_done_rounded : Icons.cloud_off_rounded),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            FirebaseRuntime.configured
                                ? tx('إعدادات Firebase موجودة', 'Firebase ayarları hazır', 'Firebase configuration detected')
                                : tx('يلزم تمرير إعدادات Firebase عند التشغيل', 'Firebase çalışma ayarları gerekli', 'Firebase runtime configuration is required'),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: tx('البريد الإلكتروني', 'E-posta', 'Email')),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        onSubmitted: (_) => login(),
                        decoration: InputDecoration(labelText: tx('كلمة المرور', 'Şifre', 'Password')),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: loading ? null : login,
                          icon: loading
                              ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.login_rounded),
                          label: Text(tx('تسجيل الدخول', 'Giriş yap', 'Sign in')),
                        ),
                      ),
                      if (message != null) ...[
                        const SizedBox(height: 16),
                        Text(message!),
                      ],
                      if (session != null) ...[
                        const Divider(height: 32),
                        Text('${tx('المستخدم', 'Kullanıcı', 'User')}: ${session!.email}'),
                        Text('${tx('الدور', 'Rol', 'Role')}: ${session!.role}'),
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
