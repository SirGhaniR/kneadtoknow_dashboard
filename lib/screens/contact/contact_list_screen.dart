import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_theme.dart';
import '../../models/contact.dart';
import '../../providers/contact_provider.dart';
import '../../utils/time_ago.dart';
import '../../widgets/admin_scaffold.dart';
import '../../widgets/contact_detail_dialog.dart';
import 'contact_reply_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactProvider>();

    return AdminScaffold(title: 'Kontak', child: _buildBody(provider));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactProvider>().load();
    });
  }

  Widget _buildBody(ContactProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.load(page: provider.currentPage),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Kontak - Management',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const _InfoBanner(),
          const SizedBox(height: 16),
          _buildList(provider),
          const SizedBox(height: 16),
          _buildPagination(provider),
        ],
      ),
    );
  }

  Widget _buildList(ContactProvider provider) {
    if (provider.isLoading && provider.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error != null && provider.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            spacing: 12,
            children: [
              Text(provider.error!),
              ElevatedButton(
                onPressed: () => provider.load(),
                child: const Text('COBA LAGI'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text('Belum ada pesan')),
      );
    }

    return Column(
      spacing: 12,
      children: provider.items
          .map(
            (c) => _ContactTile(
              contact: c,
              onTap: () => _showDetail(c),
              onMarkRead: c.isRead ? null : () => _markRead(c),
              onDelete: () => _confirmDelete(c),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPagination(ContactProvider provider) {
    if (provider.lastPage <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        OutlinedButton(
          onPressed: provider.currentPage > 1
              ? () => provider.load(page: provider.currentPage - 1)
              : null,
          child: const Text('PREV'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Page ${provider.currentPage} of ${provider.lastPage}',
            style: const TextStyle(fontSize: 13),
          ),
        ),
        OutlinedButton(
          onPressed: provider.currentPage < provider.lastPage
              ? () => provider.load(page: provider.currentPage + 1)
              : null,
          child: const Text('NEXT'),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(Contact contact) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Hapus pesan?'),
        content: Text('Yakin ingin menghapus pesan dari "${contact.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('BATAL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('HAPUS'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    final provider = context.read<ContactProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final ok = await provider.delete(contact.id);
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(ok ? 'Pesan dihapus' : 'Gagal menghapus')),
    );
  }

  Future<void> _markRead(Contact contact) async {
    final provider = context.read<ContactProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final ok = await provider.markRead(contact.id);
    if (!mounted) return;
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Gagal menandai dibaca')),
      );
    }
  }

  void _showDetail(Contact contact) {
    showDialog(
      context: context,
      builder: (_) => ContactDetailDialog(contact: contact),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final VoidCallback? onMarkRead;
  final VoidCallback onDelete;

  const _ContactTile({
    required this.contact,
    required this.onTap,
    required this.onMarkRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: contact.isRead ? AppColors.gray300 : AppColors.yellow600,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: Text(
                      contact.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (!contact.isRead)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      color: AppColors.yellow100,
                      child: const Text(
                        'Baru',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.yellow800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                contact.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppColors.gray600),
              ),
              Text(
                contact.subject.isEmpty ? '(tanpa subjek)' : contact.subject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                contact.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppColors.gray600),
              ),
              Row(
                spacing: 12,
                children: [
                  Text(
                    timeAgo(contact.createdAt),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.gray500,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ContactReplyScreen(contact: contact),
                        ),
                      );
                    },
                    icon: const Icon(Icons.reply_outlined),
                    iconSize: 18,
                    color: const Color(0xFF3B82F6),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Reply',
                  ),
                  if (onMarkRead != null)
                    IconButton(
                      onPressed: onMarkRead,
                      icon: const Icon(Icons.mark_email_read_outlined),
                      iconSize: 18,
                      color: const Color(0xFF10B981),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Mark as Read',
                    ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    iconSize: 18,
                    color: AppColors.red400,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Hapus',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.yellow50,
        border: Border.all(color: AppColors.yellow600),
      ),
      child: const Text(
        'Kontak dibuat melalui form dalam website sehingga tidak bisa dibuat secara manual.',
        style: TextStyle(fontSize: 13, color: AppColors.yellow800),
      ),
    );
  }
}
