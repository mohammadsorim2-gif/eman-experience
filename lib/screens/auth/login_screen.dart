import 'package:flutter/material.dart';

import '../../core/auth/app_role.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.onSignIn,
    required this.languageCode,
    super.key,
  });

  final Future<String?> Function({
    required String email,
    required String password,
    AppRole? role,
  }) onSignIn;
  final String languageCode;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  String _tx({required String tr, required String ar, required String en}) {
    return switch (widget.languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.onSignIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = result;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF031B2D), Color(0xFF075C8C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 40,
                      offset: Offset(0, 18),
                      color: Color(0x33000000),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/logos/Eman logo.png',
                          height: 58,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.hub_rounded,
                            size: 48,
                            color: Color(0xFF0879B8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        _tx(
                          tr: 'EMAN ONE’a giriş yapın',
                          ar: 'تسجيل الدخول إلى EMAN ONE',
                          en: 'Sign in to EMAN ONE',
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _tx(
                          tr: 'Yetkinize göre çalışma alanınıza güvenli şekilde erişin.',
                          ar: 'ادخل بأمان إلى مساحة عملك حسب صلاحياتك.',
                          en: 'Securely access your workspace based on your role.',
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        decoration: InputDecoration(
                          labelText: _tx(tr: 'E-posta', ar: 'البريد الإلكتروني', en: 'Email'),
                          prefixIcon: const Icon(Icons.alternate_email_rounded),
                        ),
                        validator: (value) => value == null || !value.contains('@')
                            ? _tx(tr: 'Geçerli e-posta girin', ar: 'أدخل بريدًا صحيحًا', en: 'Enter a valid email')
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        autofillHints: const [AutofillHints.password],
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: _tx(tr: 'Şifre', ar: 'كلمة المرور', en: 'Password'),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(_obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                          ),
                        ),
                        validator: (value) => value == null || value.length < 6
                            ? _tx(tr: 'En az 6 karakter', ar: '6 أحرف على الأقل', en: 'At least 6 characters')
                            : null,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 14),
                        Text(
                          _tx(tr: 'Giriş bilgileri geçersiz', ar: 'بيانات الدخول غير صحيحة', en: 'Invalid sign-in details'),
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ],
                      const SizedBox(height: 22),
                      FilledButton.icon(
                        onPressed: _loading ? null : _submit,
                        icon: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.login_rounded),
                        label: Text(
                          _tx(tr: 'Giriş yap', ar: 'تسجيل الدخول', en: 'Sign in'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
