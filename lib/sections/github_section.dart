import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_colors.dart';
import '../widgets/section_header.dart';
import '../widgets/glass_card.dart';

class GithubSection extends StatelessWidget {
  const GithubSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: size.width * 0.1,
      ),
      child: Column(
        children: [
          const SectionHeader(
            title: "Open Source Contributions",
            subtitle: "GitHub",
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 60),
          GlassCard(
            hasGlow: true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.github,
                      size: 40,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "@kheameshsoni",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(24, (colIndex) {
                          return Column(
                            children: List.generate(7, (rowIndex) {
                              final color = _getContributionColor(
                                colIndex,
                                rowIndex,
                              );
                              return Container(
                                width: 14,
                                height: 14,
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: color.a > 0.5
                                      ? [
                                          BoxShadow(
                                            color: color.withValues(alpha: 0.2),
                                            blurRadius: 4,
                                          ),
                                        ]
                                      : null,
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(
                      duration: 3.seconds,
                      color: AppColors.whiteTransparent.withValues(alpha: 0.1),
                    ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat("Repositories", "45"),
                    _buildStat("Followers", "1.2k"),
                    _buildStat("Contributions", "800+"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getContributionColor(int col, int row) {
    final random = (col * 7 + row) % 10;
    if (random < 3) return AppColors.white.withValues(alpha: 0.05);
    if (random < 6) return const Color(0xFF0D4429);
    if (random < 8) return const Color(0xFF006D32);
    if (random < 9) return const Color(0xFF26A641);
    return const Color(0xFF39D353);
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary.withValues(alpha: 0.38),
          ),
        ),
      ],
    );
  }
}
