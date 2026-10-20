import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/api_config.dart';
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
      backgroundColor: AppColors.gray100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FadeSlideIn(
                  offset: Offset(0, -0.1),
                  delay: Duration(milliseconds: 100),
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    'KTK',
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                FadeSlideIn(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 100),
                  offset: const Offset(0, 0.05),
                  child: Container(
                    width: 448,
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
                      children: [
                        const FadeSlideIn(
                          offset: Offset(0, -0.1),
                          delay: Duration(milliseconds: 180),
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gray900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const FadeSlideIn(
                          offset: Offset(0, 0.2),
                          delay: Duration(milliseconds: 220),
                          duration: Duration(milliseconds: 400),
                          child: Text(
                            'Welcome! Login di sini untuk membuktikan kamu admin.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.gray900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          child: auth.error != null
                              ? Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  color: AppColors.red100,
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
                          offset: const Offset(0.1, 0),
                          delay: const Duration(milliseconds: 250),
                          duration: const Duration(milliseconds: 400),
                          child: TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(
                                  color: AppColors.gray500,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(
                                  color: AppColors.gray500,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(
                                  color: AppColors.gray900,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        FadeSlideIn(
                          offset: const Offset(0.1, 0),
                          delay: const Duration(milliseconds: 300),
                          duration: const Duration(milliseconds: 400),
                          child: TextField(
                            controller: _passCtrl,
                            obscureText: true,
                            style: const TextStyle(fontSize: 15),
                            onSubmitted: (_) => _submit(),
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(
                                  color: AppColors.gray500,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(
                                  color: AppColors.gray500,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(
                                  color: AppColors.gray900,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        FadeSlideIn(
                          offset: const Offset(0, 0.2),
                          delay: const Duration(milliseconds: 350),
                          duration: const Duration(milliseconds: 400),
                          child: SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gray900,
                                foregroundColor: AppColors.gray200,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
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
                                          color: AppColors.gray200,
                                        ),
                                      )
                                    : const Text(
                                        'LOGIN',
                                        key: ValueKey('text'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                FadeSlideIn(
                  offset: const Offset(0, 0.2),
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 400),
                  child: GestureDetector(
                    onTap: _openWebsite,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6,
                      children: [
                        Icon(
                          Icons.rotate_left,
                          size: 13,
                          color: AppColors.gray500,
                        ),
                        Text(
                          'Go to Knead To Know',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  Future<void> _openWebsite() async {
    final uri = Uri.parse(ApiConfig.websiteUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
  }
}
