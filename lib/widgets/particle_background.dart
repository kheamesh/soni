import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';
import '../controllers/cursor_controller.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<StarParticle> _particles = [];
  final int _starCount = 2000;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    for (int i = 0; i < _starCount; i++) {
      _particles.add(StarParticle());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cursorController = Get.find<CursorController>();

    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final mousePos = cursorController.pointerPos.value;
          for (var particle in _particles) {
            particle.update(mousePos);
          }
          return CustomPaint(
            painter: StarPainter(_particles, mousePos),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class StarParticle {
  Offset position;
  Offset velocity;
  final double baseSize;
  double currentScale = 1.0;
  double currentOpacity;
  final double baseOpacity;

  StarParticle()
      : position = Offset(Random().nextDouble() * 2500, Random().nextDouble() * 2500),
        velocity = Offset((Random().nextDouble() - 0.5) * 0.2, (Random().nextDouble() - 0.5) * 0.2),
        baseSize = Random().nextDouble() * 2 + 0.3,
        baseOpacity = Random().nextDouble() * 0.5 + 0.1,
        currentOpacity = 0.0 {
    currentOpacity = baseOpacity;
  }

  void update(Offset mousePos) {
    position += velocity;

    double dist = (position - mousePos).distance;
    const double interactionRadius = 200.0;
    const double vanishRadius = 60.0;

    if (dist < interactionRadius) {
      double force = (interactionRadius - dist) / interactionRadius;
      Offset dir = (position - mousePos) / dist;
      position += dir * force * 5.0;

      if (dist < vanishRadius) {
        currentScale = _lerp(currentScale, 0.0, 0.15);
        currentOpacity = _lerp(currentOpacity, 0.0, 0.15);
      } else {
        currentScale = _lerp(currentScale, 2.0, 0.1);
        currentOpacity = _lerp(currentOpacity, 0.9, 0.1);
      }
    } else {
      currentScale = _lerp(currentScale, 1.0, 0.05);
      currentOpacity = _lerp(currentOpacity, baseOpacity, 0.05);
    }

    if (position.dx < -100) position = Offset(2500, position.dy);
    if (position.dx > 2500) position = Offset(-100, position.dy);
    if (position.dy < -100) position = Offset(position.dx, 2500);
    if (position.dy > 2500) position = Offset(position.dx, -100);
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}

class StarPainter extends CustomPainter {
  final List<StarParticle> stars;
  final Offset mousePos;

  StarPainter(this.stars, this.mousePos);

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()..style = PaintingStyle.fill;
    final auraPaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (var star in stars) {
      if (star.currentOpacity < 0.01) continue;

      double dist = (star.position - mousePos).distance;
      if (dist < 150) {
        auraPaint.color = AppColors.primary.withValues(alpha: (1 - dist / 150) * 0.2);
        auraPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
        canvas.drawCircle(star.position, star.baseSize * star.currentScale * 6, auraPaint);
        
        linePaint.color = AppColors.primary.withValues(alpha: (1 - dist / 150) * 0.3);
        canvas.drawLine(star.position, mousePos, linePaint);
      }

      starPaint.color = Colors.white.withValues(alpha: star.currentOpacity.clamp(0.0, 1.0));
      canvas.drawCircle(star.position, star.baseSize * star.currentScale, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant StarPainter oldDelegate) => true;
}
