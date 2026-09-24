import 'package:flutter/material.dart';

import '../../widgets/admin_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminScaffold(
      title: 'Dashboard',
      child: Center(child: Text('Dashboard content coming soon')),
    );
  }
}
