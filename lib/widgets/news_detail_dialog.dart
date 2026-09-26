import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../models/news.dart';
import '../utils/image_url.dart';

class NewsDetailDialog extends StatelessWidget {
  final News news;
  final VoidCallback onEdit;

  const NewsDetailDialog({super.key, required this.news, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.gray200)),
              ),
              child: Row(
                children: [
                  const Text(
                    'Detail Berita',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    if (news.image != null && news.image!.isNotEmpty)
                      Image.network(
                        imageUrl(news.image),
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          height: 240,
                          color: AppColors.gray100,
                          child: const Icon(
                            Icons.broken_image,
                            color: AppColors.gray500,
                          ),
                        ),
                      ),
                    _section(
                      'Title',
                      Text(
                        news.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _section(
                      'Status',
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        color: news.isFeatured
                            ? AppColors.yellow100
                            : AppColors.gray100,
                        child: Text(
                          news.isFeatured ? 'Featured' : 'Normal',
                          style: TextStyle(
                            fontSize: 12,
                            color: news.isFeatured
                                ? AppColors.yellow800
                                : AppColors.gray600,
                          ),
                        ),
                      ),
                    ),
                    _section(
                      'Content',
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.gray300),
                        ),
                        child: Text(
                          news.content,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    Row(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _section(
                            'Created',
                            Text(
                              _formatDate(news.createdAt),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _section(
                            'Updated',
                            Text(
                              _formatDate(news.updatedAt),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.gray200)),
              ),
              child: Row(
                spacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onEdit();
                    },
                    child: const Text('Edit'),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year}, '
        '${two(d.hour)}:${two(d.minute)}';
  }

  Widget _section(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.gray500),
        ),
        child,
      ],
    );
  }
}
