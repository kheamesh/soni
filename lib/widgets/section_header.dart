import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final CrossAxisAlignment crossAxisAlignment;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 2,
              color: AppColors.primary,
            ).animate().slideX(begin: -1, end: 0).fadeIn(),
            const SizedBox(width: 12),
            Text(
              subtitle.toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                fontSize: 14,
              ),
            ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2, end: 0),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
