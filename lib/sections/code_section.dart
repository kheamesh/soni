import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';

class CodeSection extends StatelessWidget {
  const CodeSection({super.key});

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
            title: "Behind The Code",
            subtitle: "Development",
          ),
          const SizedBox(height: 60),
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildDot(Colors.red),
                      const SizedBox(width: 8),
                      _buildDot(Colors.amber),
                      const SizedBox(width: 8),
                      _buildDot(Colors.green),
                      const Spacer(),
                      const Text(
                        "main.dart",
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Container(
                      padding: const EdgeInsets.all(30),
                      width: double.infinity,
                      child: const SelectableText(
                        "class KheameshSoni extends FlutterDeveloper {\n"
                        "  final String name = 'Kheamesh Soni';\n"
                        "  final List<String> skills = ['Flutter', 'Dart', 'Firebase'];\n\n"
                        "  void buildAwesomeApps() {\n"
                        "    while (isCreative) {\n"
                        "      code();\n"
                        "      test();\n"
                        "      deploy();\n"
                        "    }\n"
                        "  }\n"
                        "}",
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: AppColors.primary,
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 2.seconds)
                    .shimmer(duration: 3.seconds, color: Colors.white12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
