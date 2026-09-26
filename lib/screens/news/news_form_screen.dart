import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/news.dart';
import '../../widgets/news_form.dart';

class NewsFormScreen extends StatelessWidget {
  final News news;

  const NewsFormScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(title: const Text('Edit Berita')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            NewsForm(
              news: news,
              onSaved: () => Navigator.of(context).pop(),
              onCancel: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
