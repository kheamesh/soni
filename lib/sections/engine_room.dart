import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../utils/responsive.dart';
import '../controllers/engine_controller.dart';
import '../controllers/constellation_controller.dart';
import 'technology_constellation.dart';

class EngineRoom extends StatelessWidget {
  const EngineRoom({super.key});

  @override
  Widget build(BuildContext context) {
    final engineController = Get.put(EngineController());
    Get.put(ConstellationController());
    final isMobile = Responsive.isMobile(context);
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 100,
        horizontal: isMobile ? 20 : 50,
      ),
      child: Column(
        children: [
          Text(
            AppStrings.engineMainTitle,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.9),
              fontSize: isMobile ? 18 : 24,
              letterSpacing: isMobile ? 5 : 10,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.engineDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary.withValues(alpha: 0.38),
              fontSize: isMobile ? 10 : 12,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: isMobile ? 40 : 80),
          Responsive(
            mobile: Column(
              children: [
                _buildEngineVisual(engineController, isMobile, size.width),
                const SizedBox(height: 60),
                const TechnologyConstellation(),
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        AppStrings.engineTitle,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildEngineVisual(engineController, false, size.width),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 400,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        AppStrings.techCoreTitle,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TechnologyConstellation(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngineVisual(
    EngineController controller,
    bool isMobile,
    double screenWidth,
  ) {
    return SizedBox(
      height: isMobile ? 400 : 500,
      width: double.infinity,
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: MachinePainter(
                controller.animationController.value,
                isMobile: isMobile,
                screenWidth: screenWidth,
                labels: [
                  AppStrings.archLabel,
                  AppStrings.stateLabel,
                  AppStrings.speedLabel,
                  AppStrings.secureLabel,
                  AppStrings.scalabilityLabel,
                  AppStrings.modularCodeLabel,
                  AppStrings.unitTestingLabel,
                  AppStrings.cicdPipelineLabel,
                  AppStrings.reusableCompLabel,
                  AppStrings.smoothUxLabel,
                  AppStrings.restApiLabel,
                  AppStrings.firebaseLogicLabel,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MachinePainter extends CustomPainter {
  final double animationValue;
  final bool isMobile;
  final double screenWidth;
  final List<String> labels;

  MachinePainter(
    this.animationValue, {
    required this.isMobile,
    required this.screenWidth,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = isMobile ? 0.4 : (screenWidth < 1200 ? 0.6 : 0.8);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Core pulsing energy
    final corePulse = 0.5 + 0.5 * sin(animationValue * 2 * pi * 2);
    canvas.drawCircle(
      center,
      50 * scale,
      paint..color = AppColors.primary.withValues(alpha: 0.3 + 0.4 * corePulse),
    );
    canvas.drawCircle(
      center,
      30 * scale,
      paint
        ..color = AppColors.primary
        ..style = PaintingStyle.fill,
    );

    // Rotating Gears (Background reference)
    for (int i = 0; i < 3; i++) {
      final radius = (80.0 + i * 100) * scale;
      canvas.drawCircle(
        center,
        radius,
        paint
          ..color = AppColors.white.withValues(alpha: 0.05)
          ..style = PaintingStyle.stroke,
      );
    }

    // Nodes and Ecosystem Labels
    final nodePaint = Paint()..color = AppColors.white;
    const nodeCount = 12;
    for (int i = 0; i < nodeCount; i++) {
      double angle = (i * 2 * pi) / nodeCount + (animationValue * 0.2 * pi);
      double radius = (250.0 + sin(animationValue * 2 * pi + i) * 20) * scale;
      Offset nodePos =
          center + Offset(cos(angle) * radius, sin(angle) * radius);

      canvas.drawLine(
        center,
        nodePos,
        paint..color = AppColors.primary.withValues(alpha: 0.1),
      );

      final pulseProgress = (animationValue * 2 + i / nodeCount) % 1.0;
      final pulsePos = center + (nodePos - center) * pulseProgress;
      canvas.drawCircle(
        pulsePos,
        3 * scale,
        Paint()
          ..color = AppColors.primary
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5 * scale),
      );

      canvas.drawCircle(nodePos, 4 * scale, nodePaint);
      canvas.drawCircle(
        nodePos,
        8 * scale,
        paint..color = AppColors.secondary.withValues(alpha: 0.3),
      );

      // Draw ecosystem labels next to nodes
      textPainter.text = TextSpan(
        text: labels[i % labels.length],
        style: TextStyle(
          color: AppColors.white.withValues(alpha: 0.7),
          fontSize: (isMobile ? 8 : 10) * scale,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
          letterSpacing: 1.5,
        ),
      );
      textPainter.layout();

      Offset textOffset = Offset(
        nodePos.dx + (cos(angle) * 15),
        nodePos.dy + (sin(angle) * 15) - (textPainter.height / 2),
      );

      if (cos(angle) < 0) {
        textOffset = Offset(
          textOffset.dx - textPainter.width - 20,
          textOffset.dy,
        );
      }
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant MachinePainter oldDelegate) => true;
}
