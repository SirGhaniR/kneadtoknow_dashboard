import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_theme.dart';
import '../../models/gallery.dart';
import '../../providers/gallery_provider.dart';
import '../../utils/image_url.dart';
import '../../widgets/admin_scaffold.dart';
import '../../widgets/gallery_detail_dialog.dart';
import '../../widgets/gallery_form.dart';
import 'gallery_form_screen.dart';

class GalleryListScreen extends StatefulWidget {
  const GalleryListScreen({super.key});

  @override
  State<GalleryListScreen> createState() => _GalleryListScreenState();
}

class _GalleryCard extends StatelessWidget {
  final Gallery gallery;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GalleryCard({
    required this.gallery,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: gallery.image != null && gallery.image!.isNotEmpty
                          ? Image.network(
                              imageUrl(gallery.image),
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                color: AppColors.gray100,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: AppColors.gray500,
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.gray100,
                              child: const Center(
                                child: Text(
                                  'No Image',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.gray500,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Row(
                        spacing: 4,
                        children: [
                          _overlayIcon(
                            icon: Icons.edit_outlined,
                            color: AppColors.yellow600,
                            onTap: onEdit,
                          ),
                          _overlayIcon(
                            icon: Icons.delete_outline,
                            color: const Color(0xFFF87171),
                            onTap: onDelete,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      gallery.title.isEmpty ? 'Untitled' : gallery.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (gallery.description != null &&
                        gallery.description!.isNotEmpty)
                      Text(
                        gallery.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.gray600,
                        ),
                      ),
                    const Divider(height: 8),
                    Text(
                      _formatDate(gallery.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Widget _overlayIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}

class _GalleryListScreenState extends State<GalleryListScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GalleryProvider>();

    return AdminScaffold(title: 'Galeri', child: _buildBody(provider));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GalleryProvider>().load();
    });
  }

  Widget _buildBody(GalleryProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.load(page: provider.currentPage),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Galeri - Management',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const GalleryForm(),
          const SizedBox(height: 24),
          _buildGrid(provider),
          const SizedBox(height: 16),
          _buildPagination(provider),
        ],
      ),
    );
  }

  Widget _buildGrid(GalleryProvider provider) {
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
        child: Center(child: Text('Belum ada foto')),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: provider.items.length,
      itemBuilder: (context, index) {
        final g = provider.items[index];
        return _GalleryCard(
          gallery: g,
          onTap: () => _showDetail(g),
          onEdit: () => _openEdit(g),
          onDelete: () => _confirmDelete(g),
        );
      },
    );
  }

  Widget _buildPagination(GalleryProvider provider) {
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

  Future<void> _confirmDelete(Gallery gallery) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Hapus foto?'),
        content: Text(
          'Yakin ingin menghapus "${gallery.title.isEmpty ? 'Untitled' : gallery.title}"?',
        ),
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

    final provider = context.read<GalleryProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final ok = await provider.delete(gallery.id);
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(ok ? 'Foto dihapus' : 'Gagal menghapus')),
    );
  }

  Future<void> _openEdit(Gallery gallery) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GalleryFormScreen(gallery: gallery)),
    );
  }

  void _showDetail(Gallery gallery) {
    showDialog(
      context: context,
      builder: (_) => GalleryDetailDialog(
        gallery: gallery,
        onEdit: () => _openEdit(gallery),
      ),
    );
  }
}
