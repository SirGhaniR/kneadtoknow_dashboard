import 'package:flutter/material.dart';

import '../../widgets/admin_scaffold.dart';

class ContactInfoScreen extends StatelessWidget {
  const ContactInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminScaffold(
      title: 'Info Kontak',
      child: Center(child: Text('Contact info — coming soon')),
    );
  }
}
