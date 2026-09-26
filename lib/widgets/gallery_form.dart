import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../config/app_theme.dart';
import '../models/gallery.dart';
import '../providers/gallery_provider.dart';
import '../utils/image_url.dart';

class GalleryForm extends StatefulWidget {
  final Gallery? gallery;
  final VoidCallback? onSaved;
  final VoidCallback? onCancel;

  const GalleryForm({super.key, this.gallery, this.onSaved, this.onCancel});

  @override
  State<GalleryForm> createState() => _GalleryFormState();
}

class _GalleryFormState extends State<GalleryForm> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;
  File? _pickedImage;
  String? _error;

  bool get isEdit => widget.gallery != null;

  @override
  Widget build(BuildContext context) {
    final isSaving = context.select<GalleryProvider, bool>((p) => p.isSaving);

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
            isEdit ? 'Edit Foto' : 'Upload Foto Baru',
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

          _field(
            label: 'Title',
            child: TextField(
              controller: _titleCtrl,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(hintText: 'Enter image title'),
            ),
          ),
          _field(
            label: 'Description',
            child: TextField(
              controller: _descriptionCtrl,
              minLines: 3,
              maxLines: 6,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Enter image description (optional)',
              ),
            ),
          ),
          _field(
            label: 'Image',
            child: _ImagePickerBox(
              pickedFile: _pickedImage,
              existingUrl: isEdit ? imageUrl(widget.gallery!.image) : null,
              onTap: _pickImage,
            ),
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
                      : Text(isEdit ? 'Update Foto' : 'Upload Foto'),
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
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.gallery?.title ?? '');
    _descriptionCtrl = TextEditingController(
      text: widget.gallery?.description ?? '',
    );
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
    final description = _descriptionCtrl.text.trim();

    if (title.isEmpty) {
      setState(() => _error = 'Judul wajib diisi');
      return;
    }
    if (!isEdit && _pickedImage == null) {
      setState(() => _error = 'Gambar wajib diunggah');
      return;
    }

    setState(() => _error = null);

    final provider = context.read<GalleryProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final ok = isEdit
        ? await provider.update(
            id: widget.gallery!.id,
            title: title,
            description: description,
            image: _pickedImage,
          )
        : await provider.create(
            title: title,
            description: description,
            image: _pickedImage!,
          );

    if (!mounted) return;

    if (ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(isEdit ? 'Galeri diupdate' : 'Galeri diupload')),
      );
      widget.onSaved?.call();
    } else {
      setState(() => _error = provider.error ?? 'Gagal menyimpan');
    }
  }
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
