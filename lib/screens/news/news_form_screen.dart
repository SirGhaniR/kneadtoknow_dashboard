import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/app_theme.dart';
import '../../models/news.dart';
import '../../providers/news_provider.dart';
import '../../utils/image_url.dart';

class NewsFormScreen extends StatefulWidget {
  final News? news;

  const NewsFormScreen({super.key, this.news});

  @override
  State<NewsFormScreen> createState() => _NewsFormScreenState();
}

class _ImagePickerBox extends StatelessWidget {
  final File? pickedFile;
  final String? existingUrl;
  final VoidCallback onTap;

  const _ImagePickerBox({
    required this.pickedFile,
    required this.existingUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.gray300),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (pickedFile != null) {
      return Image.file(pickedFile!, fit: BoxFit.cover, width: double.infinity);
    }
    if (existingUrl != null && existingUrl!.isNotEmpty) {
      return Image.network(
        existingUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, _, _) => _emptyState(),
      );
    }
    return _emptyState();
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 32,
            color: AppColors.gray500,
          ),
          Text('Pilih gambar', style: TextStyle(color: AppColors.gray500)),
        ],
      ),
    );
  }
}

class _NewsFormScreenState extends State<NewsFormScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late bool _isFeatured;
  File? _pickedImage;
  String? _error;

  bool get isEdit => widget.news != null;

  @override
  Widget build(BuildContext context) {
    final isSaving = context.select<NewsProvider, bool>((p) => p.isSaving);

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Berita' : 'Buat Berita'),
        actions: [
          if (isEdit)
            IconButton(
              onPressed: isSaving ? null : _delete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFFFEE2E2),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Color(0xFF991B1B),
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Judul',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(hintText: 'Judul berita'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Konten',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _contentCtrl,
              minLines: 6,
              maxLines: 12,
              decoration: const InputDecoration(hintText: 'Isi berita'),
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 8,
              children: [
                Checkbox(
                  value: _isFeatured,
                  onChanged: (v) => setState(() => _isFeatured = v ?? false),
                ),
                const Text('Featured'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Gambar',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            _ImagePickerBox(
              pickedFile: _pickedImage,
              existingUrl: isEdit ? imageUrl(widget.news!.image) : null,
              onTap: _pickImage,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : _submit,
                child: isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(isEdit ? 'SIMPAN' : 'BUAT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.news?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.news?.content ?? '');
    _isFeatured = widget.news?.isFeatured ?? false;
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Hapus berita?'),
        content: const Text('Tindakan ini tidak bisa dibatalkan.'),
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

    if (confirm != true) return;

    final provider = context.read<NewsProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final ok = await provider.delete(widget.news!.id);
    if (!mounted) return;

    if (ok) {
      messenger.showSnackBar(const SnackBar(content: Text('Berita dihapus')));
      navigator.pop();
    } else {
      setState(() => _error = provider.error ?? 'Gagal menghapus');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      imageQuality: 85,
    );
    if (file != null) {
      setState(() => _pickedImage = File(file.path));
    }
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();

    if (title.isEmpty || content.isEmpty) {
      setState(() => _error = 'Judul dan konten wajib diisi');
      return;
    }
    if (!isEdit && _pickedImage == null) {
      setState(() => _error = 'Gambar wajib diunggah');
      return;
    }

    setState(() => _error = null);

    final provider = context.read<NewsProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final ok = isEdit
        ? await provider.update(
            id: widget.news!.id,
            title: title,
            content: content,
            isFeatured: _isFeatured,
            image: _pickedImage,
          )
        : await provider.create(
            title: title,
            content: content,
            isFeatured: _isFeatured,
            image: _pickedImage!,
          );

    if (!mounted) return;

    if (ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(isEdit ? 'Berita diupdate' : 'Berita dibuat')),
      );
      navigator.pop();
    } else {
      setState(() => _error = provider.error ?? 'Gagal menyimpan');
    }
  }
}
