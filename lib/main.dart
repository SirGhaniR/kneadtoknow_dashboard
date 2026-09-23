import 'package:flutter/material.dart';

import 'config/app_theme.dart';

void main() {
  runApp(const TastyFoodApp());
}

class TastyFoodApp extends StatelessWidget {
  const TastyFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KneadToKnow Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(body: Center(child: Text('KneadToKnow Dashboard'))),
    );
  }
}
