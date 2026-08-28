import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isSignUp = false;
  bool _loading = false;
  String? _error;

  Future<void> _handleEmailAuth() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final auth = context.read<AuthService>();
    final result = _isSignUp
        ? await auth.signUpWithEmail(_emailCtrl.text.trim(), _passCtrl.text.trim())
        : await auth.signInWithEmail(_emailCtrl.text.trim(), _passCtrl.text.trim());
    setState(() {
      _loading = false;
      _error = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.storage_rounded, size: 72, color: Color(0xFF2E7D32)),
                  const SizedBox(height: 12),
                  Text('Super Storage', style: Theme.of(context).textTheme.headlineMedium),
                  const Text('आपकी फाइलें, हमेशा साथ — बिना इंटरनेट भी'),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _loading ? null : _handleEmailAuth,
                      child: Text(_loading ? '...' : (_isSignUp ? 'Sign Up' : 'Login')),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _isSignUp = !_isSignUp),
                    child: Text(_isSignUp ? 'पहले से account है? Login करें' : 'नया account बनाएं'),
                  ),
                  const Divider(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final err = await auth.signInWithGoogle();
                        if (err != null && mounted) setState(() => _error = err);
                      },
                      icon: const Icon(Icons.g_mobiledata, size: 28),
                      label: const Text('Google से Login करें'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final err = await auth.signInWithFacebook();
                        if (err != null && mounted) setState(() => _error = err);
                      },
                      icon: const Icon(Icons.facebook, color: Colors.blue),
                      label: const Text('Facebook से Login करें'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
