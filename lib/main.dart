import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/gallery_provider.dart';
import 'providers/news_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/contact/contact_list_screen.dart';
import 'screens/contact_info/contact_info_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/gallery/gallery_list_screen.dart';
import 'screens/news/news_list_screen.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiService.init();

  final auth = AuthProvider();
  await auth.loadSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
      ],
      child: const KneadToKnowApp(),
    ),
  );
}

class KneadToKnowApp extends StatelessWidget {
  const KneadToKnowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'TastyFood Dashboard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _RootRouter(),
        routes: {
          '/news': (_) => const NewsListScreen(),
          '/gallery': (_) => const GalleryListScreen(),
          '/contacts': (_) => const ContactListScreen(),
          '/contact-info': (_) => const ContactInfoScreen(),
        },
      ),
    );
  }
}

class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AuthProvider, bool>((a) => a.isLoggedIn);
    return isLoggedIn ? const DashboardScreen() : const LoginScreen();
  }
}
