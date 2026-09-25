import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../config/app_theme.dart';

class ChartComparisonDonut extends StatelessWidget {
  static const _newsColor = AppColors.gray900;
  static const _galleryColor = AppColors.yellow600;
  static const _contactColor = AppColors.gray500;

  final int newsCount;

  final int galleryCount;
  final int contactCount;
  const ChartComparisonDonut({
    super.key,
    required this.newsCount,
    required this.galleryCount,
    required this.contactCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Perbandingan Data',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 200, child: _buildChart()),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final total = newsCount + galleryCount + contactCount;
    if (total == 0) {
      return const Center(child: Text('Belum ada data'));
    }

    return Row(
      spacing: 16,
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 55,
              sections: [
                _section(newsCount, total, _newsColor),
                _section(galleryCount, total, _galleryColor),
                _section(contactCount, total, _contactColor),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            _legend(_newsColor, 'Berita', newsCount),
            _legend(_galleryColor, 'Galeri', galleryCount),
            _legend(_contactColor, 'Kontak', contactCount),
          ],
        ),
      ],
    );
  }

  Widget _legend(Color color, String label, int value) {
    return Row(
      spacing: 8,
      children: [
        Container(width: 14, height: 14, color: color),
        Text('$label ($value)', style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  PieChartSectionData _section(int value, int total, Color color) {
    return PieChartSectionData(
      value: value.toDouble(),
      color: color,
      title: '${((value / total) * 100).toStringAsFixed(0)}%',
      radius: 50,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }
}
