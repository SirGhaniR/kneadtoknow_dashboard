import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_theme.dart';
import '../../models/news.dart';
import '../../providers/news_provider.dart';
import '../../utils/image_url.dart';
import '../../utils/time_ago.dart';
import '../../widgets/admin_scaffold.dart';
import '../../widgets/news_detail_dialog.dart';
import '../../widgets/news_form.dart';
import 'news_form_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();

    return AdminScaffold(title: 'Berita', child: _buildBody(provider));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().load();
    });
  }

  Widget _buildBody(NewsProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.load(page: provider.currentPage),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Berita - Management',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const NewsForm(),
          const SizedBox(height: 24),
          _buildList(provider),
          const SizedBox(height: 16),
          _buildPagination(provider),
        ],
      ),
    );
  }

  Widget _buildList(NewsProvider provider) {
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
        child: Center(child: Text('Belum ada berita')),
      );
    }

    return Column(
      spacing: 12,
      children: provider.items
          .map(
            (n) => _NewsTile(
              news: n,
              onTap: () => _showDetail(n),
              onEdit: () => _openEdit(n),
              onDelete: () => _confirmDelete(n),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPagination(NewsProvider provider) {
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

  Future<void> _confirmDelete(News news) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Hapus berita?'),
        content: Text('Yakin ingin menghapus "${news.title}"?'),
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

    final provider = context.read<NewsProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final ok = await provider.delete(news.id);
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(ok ? 'Berita dihapus' : 'Gagal menghapus')),
    );
  }

  Future<void> _openEdit(News news) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => NewsFormScreen(news: news)));
  }

  void _showDetail(News news) {
    showDialog(
      context: context,
      builder: (_) =>
          NewsDetailDialog(news: news, onEdit: () => _openEdit(news)),
    );
  }
}

class _NewsTile extends StatelessWidget {
  final News news;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _NewsTile({
    required this.news,
    required this.onTap,
    required this.onEdit,
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
            border: Border.all(color: AppColors.gray300),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (news.image != null && news.image!.isNotEmpty)
                Image.network(
                  imageUrl(news.image),
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 130,
                    height: 130,
                    color: AppColors.gray100,
                    child: const Icon(
                      Icons.broken_image,
                      color: AppColors.gray500,
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
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
                              news.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (news.isFeatured)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
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
                        ],
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
                        spacing: 12,
                        children: [
                          Text(
                            timeAgo(news.createdAt),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.gray500,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit_outlined),
                            iconSize: 18,
                            color: AppColors.yellow600,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline),
                            iconSize: 18,
                            color: const Color(0xFFF87171),
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
            ],
          ),
        ),
      ),
    );
  }
}
