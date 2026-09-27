import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../models/contact.dart';
import '../models/news.dart';
import '../screens/news/news_form_screen.dart';
import '../utils/image_url.dart';
import '../utils/time_ago.dart';

Widget _sectionHeader(
  BuildContext context, {
  required String title,
  required String route,
}) {
  return Row(
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const Spacer(),
      GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: const Text(
          'Lihat semua',
          style: TextStyle(fontSize: 12, color: AppColors.gray600),
        ),
      ),
    ],
  );
}

class FeaturedNewsSection extends StatelessWidget {
  final List<News> items;

  const FeaturedNewsSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        _sectionHeader(context, title: 'Berita Unggulan', route: '/news'),
        ...items.map((n) => _featuredCard(context, n)),
      ],
    );
  }

  Widget _featuredCard(BuildContext context, News news) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.gray300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (news.image != null && news.image!.isNotEmpty)
            Image.network(
              imageUrl(news.image),
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 160,
                color: AppColors.gray100,
                child: const Icon(Icons.broken_image, color: AppColors.gray500),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                Text(
                  news.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  news.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray600,
                  ),
                ),
                Row(
                  spacing: 8,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NewsFormScreen(news: news),
                        ),
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.yellow600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Text(
                      '|',
                      style: TextStyle(color: AppColors.gray300, fontSize: 12),
                    ),
                    Text(
                      _formatDate(news.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class QuickActions extends StatelessWidget {
  final int unreadContacts;

  const QuickActions({super.key, required this.unreadContacts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const Text(
          'Aksi Cepat',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        _actionCard(
          context,
          title: 'Kelola Berita',
          subtitle: 'Tambah, edit, atau hapus berita',
          route: '/news',
        ),
        _actionCard(
          context,
          title: 'Kelola Galeri',
          subtitle: 'Upload dan kelola foto galeri',
          route: '/gallery',
        ),
        _actionCard(
          context,
          title: 'Kelola Kontak',
          subtitle: '$unreadContacts pesan belum dibaca',
          route: '/contacts',
        ),
      ],
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String route,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.gray300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.gray600),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, route),
              child: const Text('Buka Manajemen'),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentContactsSection extends StatelessWidget {
  final List<Contact> items;

  const RecentContactsSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        _sectionHeader(context, title: 'Pesan Terbaru', route: '/contacts'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.gray300),
          ),
          child: items.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Belum ada pesan',
                      style: TextStyle(color: AppColors.gray500),
                    ),
                  ),
                )
              : Column(
                  children: List.generate(
                    items.length,
                    (i) => _contactRow(items[i], isLast: i == items.length - 1),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _contactRow(Contact contact, {required bool isLast}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.gray200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  contact.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  contact.subject.isEmpty ? '(tanpa subjek)' : contact.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray600,
                  ),
                ),
                Text(
                  timeAgo(contact.createdAt),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          if (!contact.isRead)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
    );
  }
}

class RecentNewsSection extends StatelessWidget {
  final List<News> items;

  const RecentNewsSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        _sectionHeader(context, title: 'Berita Terbaru', route: '/news'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.gray300),
          ),
          child: items.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Belum ada berita',
                      style: TextStyle(color: AppColors.gray500),
                    ),
                  ),
                )
              : Column(
                  children: List.generate(
                    items.length,
                    (i) => _newsRow(
                      context,
                      items[i],
                      isLast: i == items.length - 1,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _newsRow(BuildContext context, News news, {required bool isLast}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.gray200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  news.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  timeAgo(news.createdAt),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (news.isFeatured)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              color: AppColors.yellow100,
              child: const Text(
                'Featured',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.yellow800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => NewsFormScreen(news: news)),
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.yellow600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
