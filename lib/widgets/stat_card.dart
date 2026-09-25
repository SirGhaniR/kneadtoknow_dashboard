import 'package:flutter/material.dart';

import '../config/app_theme.dart';

class StatCard extends StatelessWidget {
  final String label;
  final int value;

  const StatCard({super.key, required this.label, required this.value});

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
