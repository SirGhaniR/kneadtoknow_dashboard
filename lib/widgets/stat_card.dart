import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import 'app_shell.dart';

class StatCard extends StatefulWidget {
  final int tabIndex;
  final String label;
  final int value;

  const StatCard({
    super.key,
    required this.tabIndex,
    required this.label,
    required this.value,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () => AppTabs.of(context).goToTab(widget.tabIndex),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _pressed ? AppColors.gray100 : Colors.white,
            border: Border.all(color: AppColors.gray300),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray600,
                ),
              ),
              const SizedBox(height: 8),
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: widget.value),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray900,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(width: 80, height: 4, color: AppColors.gray900),
            ],
          ),
        ),
      ),
    );
  }
}
