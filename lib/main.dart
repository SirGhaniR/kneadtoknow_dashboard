import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/contact_info_provider.dart';
import 'providers/contact_provider.dart';
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
import 'widgets/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiService.init();

  final auth = AuthProvider();
  await auth.loadSession();

  ApiService.onUnauthorized = auth.expireSession;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => ContactInfoProvider()),
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
        title: 'Knead to Know - Admin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _RootRouter(),
      ),
    );
  }
}

class _RootRouter extends StatefulWidget {
  const _RootRouter();

  @override
  State<_RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<_RootRouter> {
  static const _screens = <Widget>[
    DashboardScreen(),
    NewsListScreen(),
    GalleryListScreen(),
    ContactListScreen(),
    ContactInfoScreen(),
  ];
  int _index = 0;

  DateTime? _lastBackPress;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AuthProvider, bool>((a) => a.isLoggedIn);

    if (!isLoggedIn) {
      return const LoginScreen();
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handleBack,
      child: AppShell(
        navIndex: _index,
        onTabSelected: (i) => setState(() => _index = i),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: KeyedSubtree(key: ValueKey(_index), child: _screens[_index]),
        ),
      ),
    );
  }

  void _handleBack(bool didPop, dynamic result) {
    if (didPop) return;

    if (_index != 0) {
      setState(() => _index = 0);
      return;
    }

    final now = DateTime.now();
    final isSecondPress =
        _lastBackPress != null &&
        now.difference(_lastBackPress!) < const Duration(seconds: 2);

    if (isSecondPress) {
      SystemNavigator.pop();
      return;
    }

    _lastBackPress = now;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Tekan sekali lagi untuk keluar'),
          duration: Duration(seconds: 2),
        ),
      );
  }
}
