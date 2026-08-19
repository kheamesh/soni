import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_colors.dart';
import '../widgets/section_header.dart';
import '../widgets/glass_card.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      key: key,
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: size.width * 0.1,
      ),
      child: Column(
        children: [
          const SectionHeader(
            title: "Professional Journey",
            subtitle: "Experience",
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 60),
          Column(
            children: List.generate(experiences.length, (index) {
              return ExperienceItem(
                exp: experiences[index],
                isLast: index == experiences.length - 1,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ExperienceItem extends StatelessWidget {
  final Map<String, String> exp;
  final bool isLast;

  const ExperienceItem({super.key, required this.exp, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  exp['period']!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  exp['company']!,
                  style: const TextStyle(color: Colors.white38, fontSize: 14),
                ),
              ],
            ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0),
          ),
          const SizedBox(width: 40),
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ).animate().scale(
                delay: 200.ms,
                duration: 400.ms,
                curve: Curves.easeOutBack,
              ),
              if (!isLast)
                Expanded(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: 1200.ms,
                    curve: Curves.easeInOutQuart,
                    builder: (context, value, child) {
                      return FractionallySizedBox(
                        heightFactor: value,
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child:
                  GlassCard(
                        hasGlow: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exp['role']!,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              exp['description']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                height: 1.6,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 800.ms)
                      .slideX(begin: 0.1, end: 0),
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, String>> experiences = [
  {
    "period": "2022 - Present",
    "company": "Tech Innovators Inc.",
    "role": "Senior Flutter Developer",
    "description":
        "Leading the mobile team in developing high-performance applications. Implemented scalable architecture and reduced app startup time by 40%.",
  },
  {
    "period": "2020 - 2022",
    "company": "Creative Solns",
    "role": "Full Stack Flutter Developer",
    "description":
        "Developed and maintained multiple cross-platform apps. Integrated complex third-party APIs and payment gateways.",
  },
];
