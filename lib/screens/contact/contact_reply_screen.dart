import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../config/app_theme.dart';
import '../../models/contact.dart';

class ContactReplyScreen extends StatefulWidget {
  final Contact contact;

  const ContactReplyScreen({super.key, required this.contact});

  @override
  State<ContactReplyScreen> createState() => _ContactReplyScreenState();
}

class _ContactReplyScreenState extends State<ContactReplyScreen> {
  late final TextEditingController _subjectCtrl;
  late final TextEditingController _bodyCtrl;
  bool _opening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(title: const Text('Balas Pesan')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.gray300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  const Text(
                    'Balas Pesan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      border: Border.all(color: AppColors.gray200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        _infoLine(
                          'Dari:',
                          '${widget.contact.name} (${widget.contact.email})',
                        ),
                        _infoLine(
                          'Subjek:',
                          widget.contact.subject.isEmpty
                              ? 'Pesan dari website'
                              : widget.contact.subject,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Pesan:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.contact.message,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.gray700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _field(
                    label: 'Subject',
                    child: TextField(
                      controller: _subjectCtrl,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(),
                    ),
                  ),
                  _field(
                    label: 'Body',
                    child: TextField(
                      controller: _bodyCtrl,
                      minLines: 12,
                      maxLines: 24,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Tulis balasan Anda di sini...',
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 10,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _opening ? null : _openGmail,
                          child: _opening
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Buka di Gmail'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _opening
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final originalSubject = widget.contact.subject.isEmpty
        ? 'Pesan dari website'
        : widget.contact.subject;
    _subjectCtrl = TextEditingController(text: 'Re: $originalSubject');
    _bodyCtrl = TextEditingController(
      text:
          '\n\n\n--- Pesan Asli ---\nDari: ${widget.contact.name} (${widget.contact.email})\n\n${widget.contact.message}',
    );
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

  Widget _infoLine(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, color: AppColors.gray900),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Future<void> _openGmail() async {
    setState(() => _opening = true);

    final email = Email(
      recipients: [widget.contact.email],
      subject: _subjectCtrl.text,
      body: _bodyCtrl.text,
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      if (mounted) {
        _showError('Gagal membuka Gmail. Pastikan aplikasi Gmail terinstall.');
      }
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
