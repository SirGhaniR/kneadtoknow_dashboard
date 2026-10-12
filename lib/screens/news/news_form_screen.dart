import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/news.dart';
import '../../widgets/news_form.dart';

class NewsFormScreen extends StatefulWidget {
  final News news;

  const NewsFormScreen({super.key, required this.news});

  @override
  State<NewsFormScreen> createState() => _NewsFormScreenState();
}

class _NewsFormScreenState extends State<NewsFormScreen> {
  bool _isDirty = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final shouldPop = await _confirmExit();
        if (shouldPop && mounted) {
          navigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.gray50,
        appBar: AppBar(title: const Text('Edit Berita')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              NewsForm(
                news: widget.news,
                onSaved: () => Navigator.of(context).pop(),
                onCancel: () => Navigator.of(context).pop(),
                onDirtyChanged: (dirty) => _isDirty = dirty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmExit() async {
    if (!_isDirty) return true;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Batalkan perubahan?'),
        content: const Text('Perubahan yang belum disimpan akan hilang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('TETAP DI SINI'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('KELUAR'),
          ),
        ],
      ),
    );

    return confirm == true;
  }
}
