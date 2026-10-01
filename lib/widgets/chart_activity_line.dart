import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/app_theme.dart';
import '../models/dashboard_stats.dart';

class ChartActivityLine extends StatelessWidget {
  static const _newsColor = AppColors.gray900;
  static const _galleryColor = AppColors.yellow600;
  static const _contactColor = AppColors.gray500;
  final ActivityGroups data;
  const ChartActivityLine({super.key, required this.data});

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
            'Aktivitas Upload',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: const [
              _LegendDot(color: _newsColor, label: 'Berita'),
              _LegendDot(color: _galleryColor, label: 'Galeri'),
              _LegendDot(color: _contactColor, label: 'Kontak'),
            ],
          ),
          SizedBox(height: 200, child: _buildChart()),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final dates = data.news;
    if (dates.isEmpty) {
      return const Center(child: Text('Belum ada aktivitas'));
    }

    final allCounts = [
      ...data.news.map((e) => e.count),
      ...data.gallery.map((e) => e.count),
      ...data.contact.map((e) => e.count),
    ];
    final maxCount = allCounts.isEmpty
        ? 0
        : allCounts.reduce((a, b) => a > b ? a : b);
    final maxY = maxCount < 1 ? 5.0 : maxCount + 2.0;
    final step = (dates.length / 5).ceil();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: maxY / 4,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: step.toDouble(),
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= dates.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat('d/M').format(dates[idx].date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          _line(data.gallery, _galleryColor),
          _line(data.contact, _contactColor),
          _line(data.news, _newsColor),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => AppColors.gray900,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final idx = spot.x.toInt();
                final date = data.news[idx].date;
                final dateStr = DateFormat('d MMM').format(date);

                final label = switch (spot.barIndex) {
                  0 => 'Galeri',
                  1 => 'Kontak',
                  _ => 'Berita',
                };

                return LineTooltipItem(
                  '$dateStr, $label: ${spot.y.toInt()}',
                  const TextStyle(
                    color: AppColors.gray100,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  LineChartBarData _line(List<ActivityItem> items, Color color) {
    return LineChartBarData(
      spots: List.generate(
        items.length,
        (i) => FlSpot(i.toDouble(), items[i].count.toDouble()),
      ),
      isCurved: false,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, color: color),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
