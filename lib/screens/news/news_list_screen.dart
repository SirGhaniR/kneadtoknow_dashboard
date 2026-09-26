import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_theme.dart';
import '../../models/news.dart';
import '../../providers/news_provider.dart';
import '../../utils/image_url.dart';
import '../../utils/time_ago.dart';
import '../../widgets/admin_scaffold.dart';
import 'news_form_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final _scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();

    return AdminScaffold(
      title: 'Berita',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: AppColors.gray900,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: const Icon(Icons.add),
      ),
      child: _buildBody(provider),
    );
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().load();
    });
  }

  Widget _buildBody(NewsProvider provider) {
    if (provider.isLoading && provider.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text(provider.error!),
            ElevatedButton(
              onPressed: () => provider.load(),
              child: const Text('COBA LAGI'),
            ),
          ],
        ),
      );
    }

    if (provider.items.isEmpty) {
      return const Center(child: Text('Belum ada berita'));
    }

    return RefreshIndicator(
      onRefresh: () => provider.load(),
      child: ListView.separated(
        controller: _scrollCtrl,
        padding: const EdgeInsets.all(16),
        itemCount: provider.items.length + (provider.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= provider.items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final news = provider.items[index];
          return _NewsTile(
            news: news,
            onTap: () => _openForm(news: news),
          );
        },
      ),
    );
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      context.read<NewsProvider>().loadMore();
    }
  }

  Future<void> _openForm({News? news}) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => NewsFormScreen(news: news)));
  }
}

class _NewsTile extends StatelessWidget {
  final News news;
  final VoidCallback onTap;

  const _NewsTile({required this.news, required this.onTap});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news.image != null && news.image!.isNotEmpty)
                Image.network(
                  imageUrl(news.image),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 100,
                    height: 100,
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
                      Text(
                        timeAgo(news.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.gray500,
                        ),
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
