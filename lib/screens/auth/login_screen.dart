import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../utils/animations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: FadeSlideIn(
              offset: const Offset(0, 0.05),
              duration: const Duration(milliseconds: 500),
              child: Container(
                width: 420,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 56,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  border: Border.all(color: AppColors.gray300),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    const FadeSlideIn(
                      delay: Duration(milliseconds: 100),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const FadeSlideIn(
                      delay: Duration(milliseconds: 180),
                      child: Text(
                        'Welcome! Login di sini untuk membuktikan kamu admin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.gray600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      child: auth.error != null
                          ? Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.all(12),
                              color: const Color(0xFFFEE2E2),
                              child: Text(
                                auth.error!,
                                style: const TextStyle(
                                  color: AppColors.red800,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    FadeSlideIn(
                      delay: const Duration(milliseconds: 260),
                      child: TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: 'Email'),
                      ),
                    ),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 320),
                      child: TextField(
                        controller: _passCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Password'),
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    FadeSlideIn(
                      delay: const Duration(milliseconds: 380),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: auth.isLoading ? null : _submit,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: auth.isLoading
                                ? const SizedBox(
                                    key: ValueKey('loading'),
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('KIRIM', key: ValueKey('text')),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
  }
}
