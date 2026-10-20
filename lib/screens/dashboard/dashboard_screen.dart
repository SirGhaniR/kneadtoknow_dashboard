import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/dashboard_provider.dart';
import '../../utils/animations.dart';
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

    return AdminScaffold(
      title: 'Dashboard',
      navIndex: 0,
      child: _buildBody(provider),
    );
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
              return const StaggeredList(
                index: 0,
                child: Text(
                  'Statistik',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            case 1:
              return StaggeredList(
                index: 1,
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    StatCard(
                      tabIndex: 1,
                      label: 'Total Berita',
                      value: stats.totalNews,
                    ),
                    StatCard(
                      tabIndex: 2,
                      label: 'Total Galeri',
                      value: stats.totalGallery,
                    ),
                    StatCard(
                      tabIndex: 3,
                      label: 'Total Kontak',
                      value: stats.totalContacts,
                    ),
                    StatCard(
                      tabIndex: 3,
                      label: 'Belum Dibaca',
                      value: stats.unreadContacts,
                    ),
                  ],
                ),
              );
            case 2:
              return StaggeredList(
                index: 2,
                child: ChartActivityLine(data: stats.activity),
              );
            case 3:
              return StaggeredList(
                index: 3,
                child: ChartComparisonDonut(
                  newsCount: stats.totalNews,
                  galleryCount: stats.totalGallery,
                  contactCount: stats.totalContacts,
                ),
              );
            case 4:
              return StaggeredList(
                index: 4,
                child: QuickActions(unreadContacts: stats.unreadContacts),
              );
            case 5:
              return StaggeredList(
                index: 5,
                child: RecentNewsSection(items: stats.recentNews),
              );
            case 6:
              return StaggeredList(
                index: 6,
                child: RecentContactsSection(items: stats.recentContacts),
              );
            default:
              return StaggeredList(
                index: 7,
                child: FeaturedNewsSection(items: stats.featuredNews),
              );
          }
        },
      ),
    );
  }
}
