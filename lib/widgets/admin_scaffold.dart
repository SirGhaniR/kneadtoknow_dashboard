import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';

class AdminScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  final int navIndex;

  const AdminScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.floatingActionButton,
    this.navIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: AppBottomNav(currentIndex: navIndex),
      body: SafeArea(
        bottom: false,
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
        ],
      ),
    );
  }
}
