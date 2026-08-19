import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../controllers/engine_controller.dart';

class EngineRoom extends StatelessWidget {
  const EngineRoom({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EngineController());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 50),
      child: Column(
        children: [
          Text(
            AppStrings.engineTitle,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 50),
          SizedBox(
            height: 600,
            width: double.infinity,
            child: ExcludeSemantics(
              child: AnimatedBuilder(
                animation: controller.animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: MachinePainter(controller.animationController.value),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MachinePainter extends CustomPainter {
  final double animationValue;
  MachinePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final corePulse = 0.5 + 0.5 * sin(animationValue * 2 * pi * 2);
    canvas.drawCircle(center, 50, paint..color = AppColors.primary.withValues(alpha: 0.3 + 0.4 * corePulse));
    canvas.drawCircle(center, 30, paint..color = AppColors.primary..style = PaintingStyle.fill);
    
    for (int i = 0; i < 3; i++) {
      final radius = 80.0 + i * 100;
      final rotation = (i % 2 == 0 ? 1 : -1) * animationValue * 2 * pi;
      
      canvas.drawCircle(center, radius, paint..color = Colors.white.withValues(alpha: 0.05)..style = PaintingStyle.stroke);
      
      const toothCount = 20;
      for (int j = 0; j < toothCount; j++) {
        final angle = rotation + (j * 2 * pi / toothCount);
        final inner = center + Offset(cos(angle) * (radius - 5), sin(angle) * (radius - 5));
        final outer = center + Offset(cos(angle) * (radius + 5), sin(angle) * (radius + 5));
        canvas.drawLine(inner, outer, paint..color = Colors.white.withValues(alpha: 0.2));
      }
    }

    final nodePaint = Paint()..color = Colors.white;
    const nodeCount = 12;
    for (int i = 0; i < nodeCount; i++) {
      double angle = (i * 2 * pi) / nodeCount + (animationValue * 0.2 * pi);
      double radius = 250.0 + sin(animationValue * 2 * pi + i) * 20;
      Offset nodePos = center + Offset(cos(angle) * radius, sin(angle) * radius);
      
      canvas.drawLine(center, nodePos, paint..color = AppColors.primary.withValues(alpha: 0.1));
      
      final pulseProgress = (animationValue * 2 + i / nodeCount) % 1.0;
      final pulsePos = center + (nodePos - center) * pulseProgress;
      canvas.drawCircle(pulsePos, 3, Paint()..color = AppColors.primary..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));

      canvas.drawCircle(nodePos, 4, nodePaint);
      canvas.drawCircle(nodePos, 8, paint..color = AppColors.secondary.withValues(alpha: 0.3));
    }
  }

  @override
  bool shouldRepaint(covariant MachinePainter oldDelegate) => true;
}
