import 'package:flutter/material.dart';

import '../../widgets/admin_scaffold.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminScaffold(
      title: 'Berita',
      child: Center(child: Text('News list — coming soon')),
    );
  }
}
