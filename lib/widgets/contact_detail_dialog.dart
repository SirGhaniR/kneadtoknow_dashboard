import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/app_theme.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';

class ContactDetailDialog extends StatelessWidget {
  final Contact contact;

  const ContactDetailDialog({super.key, required this.contact});

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
                    'Detail Pesan',
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
                    Row(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _section(
                            'Name',
                            Text(
                              contact.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _section(
                            'Email',
                            Text(
                              contact.email,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _section(
                      'Subject',
                      Text(
                        contact.subject.isEmpty
                            ? '(tanpa subjek)'
                            : contact.subject,
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
                        color: contact.isRead
                            ? const Color(0xFFDCFCE7)
                            : AppColors.yellow100,
                        child: Text(
                          contact.isRead ? 'Read' : 'Unread',
                          style: TextStyle(
                            fontSize: 12,
                            color: contact.isRead
                                ? const Color(0xFF166534)
                                : AppColors.yellow800,
                          ),
                        ),
                      ),
                    ),
                    _section(
                      'Message',
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.gray300),
                        ),
                        child: Text(
                          contact.message,
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
                              _formatDate(contact.createdAt),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _section(
                            'Updated',
                            Text(
                              _formatDate(contact.updatedAt),
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
                  if (!contact.isRead)
                    ElevatedButton(
                      onPressed: () async {
                        final provider = context.read<ContactProvider>();
                        await provider.markRead(contact.id);
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Mark as Read'),
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
