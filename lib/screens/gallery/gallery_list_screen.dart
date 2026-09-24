import 'package:flutter/material.dart';

import '../../widgets/admin_scaffold.dart';

class GalleryListScreen extends StatelessWidget {
  const GalleryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminScaffold(
      title: 'Galeri',
      child: Center(child: Text('Gallery — coming soon')),
    );
  }
}
