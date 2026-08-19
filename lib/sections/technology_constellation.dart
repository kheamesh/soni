import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../controllers/constellation_controller.dart';

class TechnologyConstellation extends StatelessWidget {
  const TechnologyConstellation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConstellationController());

    final List<Map<String, dynamic>> techs = [
      {"name": AppStrings.techFlutter, "size": 16.0, "intensity": 1.0},
      {"name": AppStrings.techDart, "size": 14.0, "intensity": 0.8},
      {"name": AppStrings.techFirebase, "size": 12.0, "intensity": 0.7},
      {"name": AppStrings.techKotlin, "size": 12.0, "intensity": 0.6},
      {"name": AppStrings.techGit, "size": 10.0, "intensity": 0.5},
      {"name": AppStrings.techCICD, "size": 11.0, "intensity": 0.6},
      {"name": AppStrings.techARVR, "size": 13.0, "intensity": 0.9},
      {"name": AppStrings.techAI, "size": 15.0, "intensity": 1.0},
    ];

    return MouseRegion(
      onHover: (e) => controller.updateHoverPos(e.localPosition),
      child: ExcludeSemantics(
        child: Container(
          height: 700,
          width: double.infinity,
          color: Colors.transparent,
          child: AnimatedBuilder(
            animation: controller.animationController,
            builder: (context, child) {
              return Obx(() {
                return CustomPaint(
                  painter: ConstellationPainter(techs, controller.animationController.value, controller.hoverPos.value),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}

class ConstellationPainter extends CustomPainter {
  final List<Map<String, dynamic>> techs;
  final double animationValue;
  final Offset hoverPos;

  ConstellationPainter(this.techs, this.animationValue, this.hoverPos);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final corePaint = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20 + 10 * sin(animationValue * 2 * pi));
    
    canvas.drawCircle(center, 40, corePaint..color = AppColors.primary.withValues(alpha: 0.3));
    canvas.drawCircle(center, 20, corePaint..color = AppColors.primary.withValues(alpha: 1.0));
    
    textPainter.text = const TextSpan(
      text: AppStrings.techCore,
      style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2),
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));

    for (int i = 0; i < techs.length; i++) {
      final tech = techs[i];
      double angle = (i * 2 * pi / techs.length) + (animationValue * 2 * pi);
      double radius = 220 + sin(animationValue * 2 * pi + i) * 30;
      Offset techPos = center + Offset(cos(angle) * radius, sin(angle) * radius);

      canvas.drawLine(
        center,
        techPos,
        Paint()..color = AppColors.primary.withValues(alpha: 0.05)..strokeWidth = 0.5,
      );

      double dist = (techPos - hoverPos).distance;
      if (dist < 250) {
        canvas.drawLine(
          techPos,
          hoverPos,
          Paint()..color = AppColors.primary.withValues(alpha: (1 - dist / 250) * 0.5)..strokeWidth = 1,
        );
      }

      final starIntensity = (tech['intensity'] as num).toDouble() * (0.8 + 0.2 * sin(animationValue * 2 * pi * 3 + i));
      canvas.drawCircle(
        techPos,
        4,
        Paint()..color = AppColors.primary.withValues(alpha: starIntensity)..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0 * starIntensity),
      );
      canvas.drawCircle(techPos, 2, Paint()..color = Colors.white);

      textPainter.text = TextSpan(
        text: tech['name'],
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: tech['size'] as double,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: AppColors.secondary.withValues(alpha: 0.5), blurRadius: 10),
          ],
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, techPos + const Offset(15, -10));
    }
  }

  @override
  bool shouldRepaint(covariant ConstellationPainter oldDelegate) => true;
}
