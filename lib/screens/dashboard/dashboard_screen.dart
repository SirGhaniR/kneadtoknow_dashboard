import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/dashboard_provider.dart';
import '../../widgets/admin_scaffold.dart';
import '../../widgets/chart_activity_line.dart';
import '../../widgets/chart_comparison_donut.dart';
import '../../widgets/dashboard_sections.dart';
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
    if (provider.stats == null) {
      if (provider.error != null) {
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
      return const Center(child: CircularProgressIndicator());
    }

    final stats = provider.stats!;

    return RefreshIndicator(
      onRefresh: () => provider.load(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        separatorBuilder: (_, _) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return const Text(
                'Statistik',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              );
            case 1:
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  StatCard(
                    route: '/news',
                    label: 'Total Berita',
                    value: stats.totalNews,
                  ),
                  StatCard(
                    route: '/gallery',
                    label: 'Total Galeri',
                    value: stats.totalGallery,
                  ),
                  StatCard(
                    route: '/contacts',
                    label: 'Total Kontak',
                    value: stats.totalContacts,
                  ),
                  StatCard(
                    route: '/contacts',
                    label: 'Belum Dibaca',
                    value: stats.unreadContacts,
                  ),
                ],
              );
            case 2:
              return ChartActivityLine(data: stats.activity);
            case 3:
              return ChartComparisonDonut(
                newsCount: stats.totalNews,
                galleryCount: stats.totalGallery,
                contactCount: stats.totalContacts,
              );
            case 4:
              return QuickActions(unreadContacts: stats.unreadContacts);
            case 5:
              return RecentNewsSection(items: stats.recentNews);
            case 6:
              return RecentContactsSection(items: stats.recentContacts);
            default:
              return FeaturedNewsSection(items: stats.featuredNews);
          }
        },
      ),
    );
  }
}
