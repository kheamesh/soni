import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../utils/responsive.dart';
import '../controllers/constellation_controller.dart';

class TechnologyConstellation extends StatelessWidget {
  const TechnologyConstellation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConstellationController());
    final isMobile = Responsive.isMobile(context);
    final size = MediaQuery.of(context).size;

    final List<Map<String, dynamic>> techs = [
      {
        "name": AppStrings.techFlutter,
        "size": isMobile ? 12.0 : 16.0,
        "intensity": 1.0,
      },
      {
        "name": AppStrings.techDart,
        "size": isMobile ? 10.0 : 14.0,
        "intensity": 0.8,
      },
      {
        "name": AppStrings.techFirebase,
        "size": isMobile ? 10.0 : 12.0,
        "intensity": 0.7,
      },
      {
        "name": AppStrings.techKotlin,
        "size": isMobile ? 10.0 : 12.0,
        "intensity": 0.6,
      },
      {
        "name": AppStrings.techGit,
        "size": isMobile ? 9.0 : 10.0,
        "intensity": 0.5,
      },
      {
        "name": AppStrings.techCICD,
        "size": isMobile ? 9.0 : 11.0,
        "intensity": 0.6,
      },
      {
        "name": AppStrings.techARVR,
        "size": isMobile ? 11.0 : 13.0,
        "intensity": 0.9,
      },
      {
        "name": AppStrings.techAI,
        "size": isMobile ? 12.0 : 15.0,
        "intensity": 1.0,
      },
    ];

    return MouseRegion(
      onHover: (e) => controller.updateHoverPos(e.localPosition),
      child: ExcludeSemantics(
        child: Container(
          height: isMobile ? 500 : 700,
          width: double.infinity,
          color: AppColors.transparent,
          child: AnimatedBuilder(
            animation: controller.animationController,
            builder: (context, child) {
              return Obx(() {
                return CustomPaint(
                  painter: ConstellationPainter(
                    techs,
                    controller.animationController.value,
                    controller.hoverPos.value,
                    isMobile: isMobile,
                    screenWidth: size.width,
                  ),
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
  final bool isMobile;
  final double screenWidth;

  ConstellationPainter(
    this.techs,
    this.animationValue,
    this.hoverPos, {
    required this.isMobile,
    required this.screenWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final scale = isMobile ? 0.6 : (screenWidth < 1200 ? 0.8 : 1.0);

    final corePaint = Paint()
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        (20 + 10 * sin(animationValue * 2 * pi)) * scale,
      );

    canvas.drawCircle(
      center,
      40 * scale,
      corePaint..color = AppColors.primary.withValues(alpha: 0.3),
    );
    canvas.drawCircle(
      center,
      20 * scale,
      corePaint..color = AppColors.primary.withValues(alpha: 1.0),
    );

    textPainter.text = TextSpan(
      text: AppStrings.techCore,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 10 * scale,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );

    for (int i = 0; i < techs.length; i++) {
      final tech = techs[i];
      double angle = (i * 2 * pi / techs.length) + (animationValue * 2 * pi);
      double radius = (220 + sin(animationValue * 2 * pi + i) * 30) * scale;
      Offset techPos =
          center + Offset(cos(angle) * radius, sin(angle) * radius);

      canvas.drawLine(
        center,
        techPos,
        Paint()
          ..color = AppColors.primary.withValues(alpha: 0.05)
          ..strokeWidth = 0.5,
      );

      double dist = (techPos - hoverPos).distance;
      if (dist < 250 * scale) {
        canvas.drawLine(
          techPos,
          hoverPos,
          Paint()
            ..color = AppColors.primary.withValues(
              alpha: (1 - dist / (250 * scale)) * 0.5,
            )
            ..strokeWidth = 1,
        );
      }

      final starIntensity =
          (tech['intensity'] as num).toDouble() *
          (0.8 + 0.2 * sin(animationValue * 2 * pi * 3 + i));
      canvas.drawCircle(
        techPos,
        4 * scale,
        Paint()
          ..color = AppColors.primary.withValues(alpha: starIntensity)
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            10.0 * starIntensity * scale,
          ),
      );
      canvas.drawCircle(techPos, 2 * scale, Paint()..color = AppColors.white);

      textPainter.text = TextSpan(
        text: tech['name'],
        style: TextStyle(
          color: AppColors.white.withValues(alpha: 0.9),
          fontSize: (tech['size'] as double) * scale,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: AppColors.secondary.withValues(alpha: 0.5),
              blurRadius: 10 * scale,
            ),
          ],
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, techPos + Offset(15 * scale, -10 * scale));
    }
  }

  @override
  bool shouldRepaint(covariant ConstellationPainter oldDelegate) => true;
}
