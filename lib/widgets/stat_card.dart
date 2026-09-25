import 'package:flutter/material.dart';

import '../config/app_theme.dart';

class StatCard extends StatelessWidget {
  final String route;
  final String label;
  final int value;

  const StatCard({
    super.key,
    required this.route,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.gray300),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.gray600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.gray900,
              ),
            ),
            const SizedBox(height: 8),
            Container(width: 80, height: 4, color: AppColors.gray900),
          ],
        ),
      ),
    );
  }
}
