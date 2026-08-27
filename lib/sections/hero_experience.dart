import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../utils/responsive.dart';
import '../controllers/hero_experience_controller.dart';
import '../widgets/custom_cursor.dart';

class HeroExperience extends StatelessWidget {
  const HeroExperience({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HeroExperienceController());
    final size = MediaQuery.of(context).size;
    final isDesktop =
        Responsive.isDesktop(context) ||
        Responsive.isExtraLargeDesktop(context);

    return Container(
      height: isDesktop ? size.height : null,
      width: double.infinity,
      color: AppColors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: Get.width * 0.1,
        vertical: isDesktop ? 0 : Get.height * 0.12,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: const ExcludeSemantics(child: ScanlineOverlay()),
          ),

          Responsive(
            mobile: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEngineerInfo(context, isDesktop: false),
                SizedBox(height: Get.height * 0.06),
                const SmartphoneAssembler(),
              ],
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildEngineerInfo(context, isDesktop: true),
                ),
                SizedBox(width: Get.width * 0.04),
                const Expanded(
                  flex: 2,
                  child: Center(child: SmartphoneAssembler()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngineerInfo(BuildContext context, {required bool isDesktop}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
              AppStrings.heroEngineer,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(duration: const Duration(milliseconds: 800))
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: 20),
        _buildAnimatedText(
          AppStrings.heroName,
          TextStyle(
            fontSize: isDesktop ? 80 : 45,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            height: 1.1,
            letterSpacing: 2,
          ),
          isDesktop: isDesktop,
        ),
        const SizedBox(height: 30),
        Text(
              AppStrings.heroDescription,
              textAlign: isDesktop ? TextAlign.left : TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop ? 22 : 16,
                color: AppColors.textPrimary.withValues(alpha: 0.7),
                height: 1.5,
              ),
            )
            .animate()
            .fadeIn(delay: const Duration(seconds: 1))
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 40),
        _buildInfoTag(AppStrings.expTag1),
        _buildInfoTag(AppStrings.expTag2),
        _buildInfoTag(AppStrings.expTag3),
        const SizedBox(height: 40),
        _buildCVButtons(context, isDesktop),
      ],
    );
  }

  Widget _buildCVButtons(BuildContext context, bool isDesktop) {
    final controller = Get.find<HeroExperienceController>();
    return Row(
      mainAxisAlignment:
          isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        _buildActionButton(
          label: AppStrings.viewCV,
          onPressed: controller.viewCV,
          isPrimary: true,
        ),
        const SizedBox(width: 20),
        _buildActionButton(
          label: AppStrings.downloadCV,
          onPressed: controller.downloadCV,
          isPrimary: false,
        ),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 1500)).slideY(
      begin: 0.2,
      end: 0,
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = true,
  }) {
    return CursorHoverRegion(
      text: label,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isPrimary ? AppColors.black : AppColors.primary,
          backgroundColor:
              isPrimary ? AppColors.primary : AppColors.transparent,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedText(
    String text,
    TextStyle style, {
    Duration delay = Duration.zero,
    required bool isDesktop,
  }) {
    return Column(
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: text.split('\n').map((line) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: isDesktop
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: line.split('').asMap().entries.map((entry) {
            return Text(entry.value, style: style)
                .animate(delay: delay + Duration(milliseconds: entry.key * 50))
                .fadeIn(duration: const Duration(milliseconds: 300))
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutBack)
                .shimmer(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(seconds: 1),
                  color: AppColors.primary,
                );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildInfoTag(String text) {
    return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 6, height: 6, color: AppColors.primary),
              const SizedBox(width: 15),
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 1200))
        .slideX(begin: 0.1, end: 0);
  }
}

class SmartphoneAssembler extends StatelessWidget {
  const SmartphoneAssembler({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HeroExperienceController>();
    final isMobile = Responsive.isMobile(context);
    final scale = isMobile ? 0.7 : 1.0;

    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 400,
        height: 600,
        child: AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, child) {
            final animationValue = controller.animationController.value;
            const cardCount = 6;

            return Stack(
              alignment: Alignment.center,
              children: [
                ExcludeSemantics(
                  child: CustomPaint(
                    painter: PhonePainter(animationValue),
                    size: const Size(400, 600),
                  ),
                ),

                Container(
                  width: 180,
                  height: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FlutterLogo(size: 80)
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.1, 1.1),
                              duration: const Duration(seconds: 2),
                            )
                            .shimmer(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                        const SizedBox(height: 30),
                        const CodeSimulator(),
                      ],
                    ),
                  ),
                ),

                ...List.generate(cardCount, (i) {
                  double angle =
                      (i * 2 * pi / cardCount) + (animationValue * pi);
                  double radius = 180 + sin(animationValue * 2 * pi + i) * 30;

                  double x = 200 + cos(angle) * radius;
                  double y = 300 + sin(angle) * radius;

                  return Positioned(
                    left: x - 25,
                    top: y - 25,
                    child: ExcludeSemantics(
                      child:
                          Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: FlutterLogo(size: 25),
                                ),
                              )
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .moveY(
                                begin: -5,
                                end: 5,
                                duration: const Duration(seconds: 2),
                                curve: Curves.easeInOut,
                              ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CodeSimulator extends StatelessWidget {
  const CodeSimulator({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> codeLines = [
      "class MyApp extends StatelessWidget {",
      "  @override",
      "  Widget build(BuildContext context) {",
      "    return MaterialApp(",
      "      home: Portfolio(),",
      "    );",
      "  }",
      "}",
    ];

    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: codeLines.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child:
                  Text(
                        entry.value,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 8,
                          fontFamily: 'monospace',
                        ),
                      )
                      .animate(delay: Duration(milliseconds: entry.key * 200))
                      .fadeIn()
                      .slideX(begin: -0.2, end: 0),
            );
          }).toList(),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          delay: const Duration(seconds: 3),
          duration: const Duration(seconds: 2),
        );
  }
}

class PhonePainter extends CustomPainter {
  final double animationValue;

  PhonePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final phoneRect = Rect.fromCenter(center: center, width: 200, height: 400);
    final RRect phoneRRect = RRect.fromRectAndRadius(
      phoneRect,
      const Radius.circular(30),
    );

    final shadowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawRRect(phoneRRect, shadowPaint);
    canvas.drawRRect(phoneRRect, paint);

    final screenRect = Rect.fromCenter(center: center, width: 180, height: 380);
    final RRect screenRRect = RRect.fromRectAndRadius(
      screenRect,
      const Radius.circular(20),
    );
    canvas.drawRRect(
      screenRRect,
      paint
        ..color = AppColors.black.withValues(alpha: 0.8)
        ..style = PaintingStyle.fill,
    );

    for (int i = 0; i < 6; i++) {
      double angle = (i * 2 * pi / 6) + (animationValue * pi);
      double radius = 180 + sin(animationValue * 2 * pi + i) * 30;
      Offset pos = center + Offset(cos(angle) * radius, sin(angle) * radius);

      canvas.drawLine(
        center + Offset(cos(angle) * 100, sin(angle) * 200),
        pos,
        paint
          ..color = AppColors.primary.withValues(alpha: 0.1)
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PhonePainter oldDelegate) => true;
}

class ScanlineOverlay extends StatelessWidget {
  const ScanlineOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child:
          Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.transparent,
                      AppColors.textPrimary.withValues(alpha: 0.05),
                      AppColors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              )
              .animate(onPlay: (c) => c.repeat())
              .custom(
                duration: const Duration(seconds: 5),
                builder: (context, value, child) => Transform.translate(
                  offset: Offset(0, (value - 0.5) * 2000),
                  child: child,
                ),
              ),
    );
  }
}
