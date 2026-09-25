import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/dashboard_provider.dart';
import '../../widgets/admin_scaffold.dart';
import '../../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return AdminScaffold(title: 'Dashboard', child: _buildBody(provider));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().load();
    });
  }

  Widget _buildBody(DashboardProvider provider) {
    if (provider.isLoading && provider.stats == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.stats == null) {
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

    final stats = provider.stats!;

    return RefreshIndicator(
      onRefresh: () => provider.load(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Statistik',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              StatCard(label: 'Total Berita', value: stats.totalNews),
              StatCard(label: 'Total Galeri', value: stats.totalGallery),
              StatCard(label: 'Total Kontak', value: stats.totalContacts),
              StatCard(label: 'Belum Dibaca', value: stats.unreadContacts),
            ],
          ),
        ],
      ),
    );
  }
}
