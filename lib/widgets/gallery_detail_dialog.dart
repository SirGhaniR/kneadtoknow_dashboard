import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../models/gallery.dart';
import '../utils/image_url.dart';

class GalleryDetailDialog extends StatelessWidget {
  final Gallery gallery;
  final VoidCallback onEdit;

  const GalleryDetailDialog({
    super.key,
    required this.gallery,
    required this.onEdit,
  });

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
                    'Detail Foto',
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
                    if (gallery.image != null && gallery.image!.isNotEmpty)
                      Image.network(
                        imageUrl(gallery.image),
                        width: double.infinity,
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
                        gallery.title.isEmpty ? 'Untitled' : gallery.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (gallery.description != null &&
                        gallery.description!.isNotEmpty)
                      _section(
                        'Description',
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.gray300),
                          ),
                          child: Text(
                            gallery.description!,
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
                              _formatDate(gallery.createdAt),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _section(
                            'Updated',
                            Text(
                              _formatDate(gallery.updatedAt),
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
      spacing: 4,
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
