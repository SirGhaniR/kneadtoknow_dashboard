import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/gallery.dart';
import '../../widgets/gallery_form.dart';

class GalleryFormScreen extends StatelessWidget {
  final Gallery gallery;

  const GalleryFormScreen({super.key, required this.gallery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(title: const Text('Edit Foto')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GalleryForm(
              gallery: gallery,
              onSaved: () => Navigator.of(context).pop(),
              onCancel: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
