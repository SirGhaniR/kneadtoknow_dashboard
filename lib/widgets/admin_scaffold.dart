import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import 'app_sidebar.dart';

class AdminScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const AdminScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: AppColors.gray900,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: const AppSidebar(),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            _Header(title: title, actions: actions),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const _Header({required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        spacing: 4,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ...?actions,
          Builder(
            builder: (ctx) => IconButton(
              onPressed: () => Scaffold.of(ctx).openDrawer(),
              icon: const Icon(Icons.menu),
              color: AppColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
