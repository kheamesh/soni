import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_colors.dart';
import '../widgets/glass_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Wrap(
        spacing: 40,
        runSpacing: 40,
        alignment: WrapAlignment.center,
        children: [
          _buildStatCard("5+", "Years Experience"),
          _buildStatCard("50+", "Projects Completed"),
          _buildStatCard("20+", "Happy Clients"),
          _buildStatCard("100%", "Quality Assurance"),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return GlassCard(
      width: 250,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary.withValues(alpha: 0.7),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
