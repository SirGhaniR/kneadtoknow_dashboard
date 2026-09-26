import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../config/app_theme.dart';
import '../models/news.dart';
import '../providers/news_provider.dart';
import '../utils/image_url.dart';

class NewsForm extends StatefulWidget {
  final News? news;
  final VoidCallback? onSaved;
  final VoidCallback? onCancel;

  const NewsForm({super.key, this.news, this.onSaved, this.onCancel});

  @override
  State<NewsForm> createState() => _NewsFormState();
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
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.gray100,
          border: Border.all(color: AppColors.gray200),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (pickedFile != null) {
      return Image.file(pickedFile!, fit: BoxFit.cover);
    }
    if (existingUrl != null && existingUrl!.isNotEmpty) {
      return Image.network(
        existingUrl!,
        fit: BoxFit.cover,
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
          Text(
            'Pilih gambar',
            style: TextStyle(fontSize: 14, color: AppColors.gray500),
          ),
          Text(
            'Accepted formats: PNG, JPG, GIF, SVG (Max: 1MB)',
            style: TextStyle(fontSize: 12, color: AppColors.gray400),
          ),
        ],
      ),
    );
  }
}

class _NewsFormState extends State<NewsForm> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late bool _isFeatured;
  File? _pickedImage;
  String? _error;

  bool get isEdit => widget.news != null;

  @override
  Widget build(BuildContext context) {
    final isSaving = context.select<NewsProvider, bool>((p) => p.isSaving);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.gray300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Text(
            isEdit ? 'Edit Berita' : 'Buat Berita Baru',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          if (_error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: const Color(0xFFFEE2E2),
              child: Text(
                _error!,
                style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13),
              ),
            ),

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 640;
              final titleField = _field(
                label: 'Title',
                child: TextField(
                  style: TextStyle(fontSize: 14),
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Enter news title',
                  ),
                ),
              );
              final featuredField = _field(
                label: 'Featured',
                child: DropdownButtonFormField<bool>(
                  initialValue: _isFeatured,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.gray500,
                  ),
                  decoration: const InputDecoration(),
                  items: const [
                    DropdownMenuItem(value: false, child: Text('No')),
                    DropdownMenuItem(value: true, child: Text('Yes')),
                  ],
                  onChanged: (v) => setState(() => _isFeatured = v ?? false),
                ),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  if (isWide)
                    Row(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: titleField),
                        Expanded(child: featuredField),
                      ],
                    )
                  else ...[
                    titleField,
                    featuredField,
                  ],
                  _field(
                    label: 'Content',
                    child: TextField(
                      style: TextStyle(fontSize: 14),
                      controller: _contentCtrl,
                      minLines: 4,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        hintText: 'Enter news content',
                      ),
                    ),
                  ),
                  _field(
                    label: 'Image',
                    child: _ImagePickerBox(
                      pickedFile: _pickedImage,
                      existingUrl: isEdit ? imageUrl(widget.news!.image) : null,
                      onTap: _pickImage,
                    ),
                  ),
                ],
              );
            },
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                      : Text(isEdit ? 'Update News' : 'Create News'),
                ),
              ),
              if (widget.onCancel != null)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: isSaving ? null : widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                ),
            ],
          ),
        ],
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

  Widget _field({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        child,
      ],
    );
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
      widget.onSaved?.call();
    } else {
      setState(() => _error = provider.error ?? 'Gagal menyimpan');
    }
  }
}
