import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_theme.dart';
import '../../providers/contact_info_provider.dart';
import '../../widgets/admin_scaffold.dart';

class ContactInfoForm extends StatefulWidget {
  final dynamic info;

  const ContactInfoForm({super.key, required this.info});

  @override
  State<ContactInfoForm> createState() => _ContactInfoFormState();
}

class ContactInfoScreen extends StatefulWidget {
  const ContactInfoScreen({super.key});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoFormState extends State<ContactInfoForm> {
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final isSaving = context.select<ContactInfoProvider, bool>(
      (p) => p.isSaving,
    );

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
            widget.info == null ? 'Buat Info Kontak' : 'Info Kontak',
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
            label: 'Email',
            child: TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(hintText: 'Enter email'),
            ),
          ),
          _field(
            label: 'Phone',
            child: TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(hintText: 'Enter phone'),
            ),
          ),
          _field(
            label: 'Address',
            child: TextField(
              controller: _addressCtrl,
              minLines: 3,
              maxLines: 6,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(hintText: 'Enter address'),
            ),
          ),

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
                  : const Text('Update Info Kontak'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ContactInfoForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.info != oldWidget.info) {
      _emailCtrl.text = widget.info?.email ?? '';
      _phoneCtrl.text = widget.info?.phone ?? '';
      _addressCtrl.text = widget.info?.address ?? '';
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.info?.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.info?.phone ?? '');
    _addressCtrl = TextEditingController(text: widget.info?.address ?? '');
  }

  Widget _field({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        child,
      ],
    );
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final address = _addressCtrl.text.trim();

    if (email.isEmpty || phone.isEmpty || address.isEmpty) {
      setState(() => _error = 'Semua field wajib diisi');
      return;
    }

    setState(() => _error = null);

    final provider = context.read<ContactInfoProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final ok = await provider.save(
      email: email,
      phone: phone,
      address: address,
    );

    if (!mounted) return;

    if (ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Info kontak disimpan')),
      );
    } else {
      setState(() => _error = provider.error ?? 'Gagal menyimpan');
    }
  }
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactInfoProvider>();

    return AdminScaffold(title: 'Info Kontak', child: _buildBody(provider));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactInfoProvider>().load();
    });
  }

  Widget _buildBody(ContactInfoProvider provider) {
    if (provider.isLoading && provider.info == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.info == null) {
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

    return RefreshIndicator(
      onRefresh: () => provider.load(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Info Kontak - Management',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ContactInfoForm(info: provider.info),
        ],
      ),
    );
  }
}
