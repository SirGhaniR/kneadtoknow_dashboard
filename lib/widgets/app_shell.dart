import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'app_bottom_nav.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final int navIndex;
  final ValueChanged<int> onTabSelected;

  const AppShell({
    super.key,
    required this.child,
    required this.navIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AuthProvider, bool>((a) => a.isLoggedIn);

    return AppTabs(
      goToTab: onTabSelected,
      child: Scaffold(
        bottomNavigationBar: isLoggedIn
            ? AppBottomNav(currentIndex: navIndex, onTabSelected: onTabSelected)
            : null,
        body: SafeArea(bottom: false, child: child),
      ),
    );
  }
}

class AppTabs extends InheritedWidget {
  final void Function(int) goToTab;

  const AppTabs({super.key, required this.goToTab, required super.child});

  @override
  bool updateShouldNotify(AppTabs oldWidget) => false;

  static AppTabs of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppTabs>()!;
  }
}
