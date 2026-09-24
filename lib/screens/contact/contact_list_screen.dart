import 'package:flutter/material.dart';

import '../../widgets/admin_scaffold.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminScaffold(
      title: 'Kontak',
      child: Center(child: Text('Contacts — coming soon')),
    );
  }
}
