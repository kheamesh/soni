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
                  title: "Transforming Ideas into Digital Reality",
                  subtitle: "About Me",
                ),
                const SizedBox(height: 30),
                Text(
                  "I am a passionate Flutter Developer with a focus on building high-quality, scalable mobile applications. With expertise in Dart and the Flutter framework, I create seamless user experiences that combine beautiful design with robust performance.",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.6),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 20),
                Text(
                  "My philosophy revolves around 'Clean Code' and 'User-Centric Design'. I believe that a great application isn't just about how it looks, but how it feels and functions under the hood. From architecture to deployment, I ensure every detail is meticulously crafted.",
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
                    _buildDetailRow("Experience", "5+ Years"),
                    _buildDetailRow("Location", "India / Remote"),
                    _buildDetailRow("Specialization", "Mobile & Web"),
                    _buildDetailRow("Available for", "Freelance / Full-time"),
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
          Text(label, style: const TextStyle(color: Colors.white70)),
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
