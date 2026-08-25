import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_colors.dart';
import '../widgets/section_header.dart';
import '../widgets/glass_card.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      key: key,
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: size.width * 0.1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: AppStrings.aboutTitle,
                  subtitle: AppStrings.aboutSubtitle,
                ),
                const SizedBox(height: 30),
                Text(
                  AppStrings.aboutDescription1,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.6),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 20),
                Text(
                  AppStrings.aboutDescription2,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.6),
                ).animate().fadeIn(delay: 800.ms),
              ],
            ),
          ),
          const SizedBox(width: 60),
          if (size.width > 900)
            Expanded(
              child: GlassCard(
                hasGlow: true,
                child: Column(
                  children: [
                    _buildDetailRow(AppStrings.labelExperience, AppStrings.valExperience),
                    _buildDetailRow(AppStrings.labelLocation, AppStrings.valLocation),
                    _buildDetailRow(AppStrings.labelSpecialization, AppStrings.valSpecialization),
                    _buildDetailRow(AppStrings.labelAvailableFor, AppStrings.valAvailableFor),
                  ],
                ),
              ).animate().fadeIn(delay: 1000.ms).slideX(begin: 0.2, end: 0),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.7))),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
