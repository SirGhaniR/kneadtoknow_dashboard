import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiService.init();

  final auth = AuthProvider();
  await auth.loadSession();

  runApp(
    ChangeNotifierProvider.value(value: auth, child: const TastyFoodApp()),
  );
}

class TastyFoodApp extends StatelessWidget {
  const TastyFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TastyFood Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _RootRouter(),
    );
  }
}

class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AuthProvider, bool>((a) => a.isLoggedIn);

    if (!isLoggedIn) return const LoginScreen();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login successful'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<AuthProvider>().logout(),
              child: const Text('LOGOUT'),
            ),
          ],
        ),
      ),
    );
  }
}
