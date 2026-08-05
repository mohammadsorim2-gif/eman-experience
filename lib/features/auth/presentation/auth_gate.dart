import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          final user = snapshot.data;
          if (user == null) return const SignInScreen();
          return _ProfileGate(user: user, child: child);
        },
      );
}

class _ProfileGate extends StatelessWidget {
  const _ProfileGate({required this.user, required this.child});
  final User user;
  final Widget child;

  @override
  Widget build(BuildContext context) => StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return _ActivationScreen(user: user);
          }
          final data = snapshot.data!.data() ?? const <String, dynamic>{};
          if (data['active'] != true) {
            return _AccessMessage(
              icon: Icons.lock_clock_outlined,
              title: 'Account pending activation',
              message: 'An administrator must activate this account before factory data can be accessed.',
            );
          }
          return child;
        },
      );
}

class _ActivationScreen extends StatefulWidget {
  const _ActivationScreen({required this.user});
  final User user;

  @override
  State<_ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<_ActivationScreen> {
  bool saving = false;

  Future<void> requestAccess() async {
    setState(() => saving = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).set({
        'email': widget.user.email ?? '',
        'displayName': widget.user.displayName ?? widget.user.email?.split('@').first ?? 'New user',
        'role': 'viewer',
        'department': 'unassigned',
        'active': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.admin_panel_settings_outlined, size: 52, color: Color(0xFF146C5A)),
                  const SizedBox(height: 16),
                  const Text('ERP access required', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(widget.user.email ?? '', style: const TextStyle(color: Color(0xFF71847F))),
                  const SizedBox(height: 20),
                  const Text('Create an access request. An owner or administrator can then assign your department and role.'),
                  const SizedBox(height: 22),
                  FilledButton.icon(onPressed: saving ? null : requestAccess, icon: const Icon(Icons.send_outlined), label: Text(saving ? 'Submitting...' : 'Request access')),
                  TextButton(onPressed: FirebaseAuth.instance.signOut, child: const Text('Sign out')),
                ]),
              ),
            ),
          ),
        ),
      );
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  bool createMode = false;
  String? error;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() { loading = true; error = null; });
    try {
      if (createMode) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text.trim(), password: password.text);
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.trim(), password: password.text);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? e.code);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> resetPassword() async {
    final value = email.text.trim();
    if (value.isEmpty) {
      setState(() => error = 'Enter your email address first.');
      return;
    }
    await FirebaseAuth.instance.sendPasswordResetEmail(email: value);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset email sent.')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(children: [
          if (MediaQuery.sizeOf(context).width >= 900)
            Expanded(
              child: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0C2E28), Color(0xFF1F8A70)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                padding: const EdgeInsets.all(56),
                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.bubble_chart_rounded, color: Color(0xFF55D9B2), size: 64),
                  SizedBox(height: 28),
                  Text('Eman Experience ERP', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900)),
                  SizedBox(height: 14),
                  Text('Secure control of production, batches, quality, inventory, and shipping.', style: TextStyle(color: Color(0xFFD3EEE6), fontSize: 18, height: 1.5)),
                ]),
              ),
            ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text(createMode ? 'Create account' : 'Welcome back', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    Text(createMode ? 'Create a secure account, then request ERP access.' : 'Sign in to continue to factory operations.', style: const TextStyle(color: Color(0xFF71847F))),
                    const SizedBox(height: 28),
                    TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline))),
                    const SizedBox(height: 14),
                    TextField(controller: password, obscureText: true, onSubmitted: (_) => submit(), decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline))),
                    if (error != null) ...[const SizedBox(height: 12), Text(error!, style: const TextStyle(color: Colors.red))],
                    const SizedBox(height: 20),
                    FilledButton(onPressed: loading ? null : submit, child: Padding(padding: const EdgeInsets.all(14), child: Text(loading ? 'Please wait...' : createMode ? 'Create account' : 'Sign in'))),
                    if (!createMode) TextButton(onPressed: resetPassword, child: const Text('Forgot password?')),
                    const Divider(height: 34),
                    TextButton(onPressed: () => setState(() { createMode = !createMode; error = null; }), child: Text(createMode ? 'Already have an account? Sign in' : 'New employee? Create account')),
                  ]),
                ),
              ),
            ),
          ),
        ]),
      );
}

class _AccessMessage extends StatelessWidget {
  const _AccessMessage({required this.icon, required this.title, required this.message});
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 56, color: const Color(0xFF146C5A)),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 18),
          OutlinedButton.icon(onPressed: FirebaseAuth.instance.signOut, icon: const Icon(Icons.logout), label: const Text('Sign out')),
        ]))),
      );
}
