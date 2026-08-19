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
  final Rocket _rocket = Rocket();
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
          _rocket.update();
          
          return CustomPaint(
            painter: CombinedBackgroundPainter(
              stars: _particles,
              rocket: _rocket,
              mousePos: mousePos,
              animationValue: _controller.value,
            ),
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
    : position = Offset(
        Random().nextDouble() * 2500,
        Random().nextDouble() * 2500,
      ),
      velocity = Offset(
        (Random().nextDouble() - 0.5) * 0.2,
        (Random().nextDouble() - 0.5) * 0.2,
      ),
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

class Rocket {
  Offset position = Offset.zero;
  double speed = 0;
  double size = 15; // Smaller base size
  double angle = 0;
  bool isActive = false;
  final Random _random = Random();

  void update() {
    if (!isActive) {
      // Increased spawn chance to ensure a rocket appears roughly every 10-15 seconds
      // 3600 frames per minute / 600 chance = ~6 spawns/min (one every 10s avg)
      if (_random.nextInt(600) == 0) {
        _spawn();
      }
      return;
    }

    // Straight slow movement
    position += Offset(cos(angle) * speed, sin(angle) * speed);

    if (position.dx < -500 || position.dx > 3000 || position.dy < -500 || position.dy > 3000) {
      isActive = false;
    }
  }

  void _spawn() {
    int side = _random.nextInt(4);
    double startX, startY;
    
    switch (side) {
      case 0: // Left
        startX = -100;
        startY = _random.nextDouble() * 2000;
        angle = (_random.nextDouble() - 0.5) * pi / 2.5; 
        break;
      case 1: // Right
        startX = 2600;
        startY = _random.nextDouble() * 2000;
        angle = pi + (_random.nextDouble() - 0.5) * pi / 2.5;
        break;
      case 2: // Top
        startX = _random.nextDouble() * 2500;
        startY = -100;
        angle = pi / 2 + (_random.nextDouble() - 0.5) * pi / 2.5;
        break;
      default: // Bottom
        startX = _random.nextDouble() * 2500;
        startY = 2100;
        angle = -pi / 2 + (_random.nextDouble() - 0.5) * pi / 2.5;
        break;
    }

    position = Offset(startX, startY);
    speed = _random.nextDouble() * 0.8 + 1.2; // Slow speed for distance feel
    size = _random.nextDouble() * 5 + 12; // Small size (12-17px)
    isActive = true;
  }
}

class CombinedBackgroundPainter extends CustomPainter {
  final List<StarParticle> stars;
  final Rocket rocket;
  final Offset mousePos;
  final double animationValue;

  CombinedBackgroundPainter({
    required this.stars,
    required this.rocket,
    required this.mousePos,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()..style = PaintingStyle.fill;
    final auraPaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // 1. Draw Rare Rocket first (so stars appear on top/around it)
    if (rocket.isActive) {
      canvas.save();
      canvas.translate(rocket.position.dx, rocket.position.dy);
      canvas.rotate(rocket.angle + pi / 2);

      final rSize = rocket.size;
      const opacity = 0.25; // Faded for distance
      
      // Rocket Body (Faded White)
      final bodyPaint = Paint()..color = Colors.white.withValues(alpha: opacity);
      final bodyPath = Path();
      bodyPath.moveTo(0, -rSize * 1.2); 
      bodyPath.quadraticBezierTo(rSize * 0.4, -rSize * 0.8, rSize * 0.4, 0); 
      bodyPath.lineTo(rSize * 0.4, rSize * 0.8); 
      bodyPath.lineTo(-rSize * 0.4, rSize * 0.8); 
      bodyPath.lineTo(-rSize * 0.4, 0); 
      bodyPath.quadraticBezierTo(-rSize * 0.4, -rSize * 0.8, 0, -rSize * 1.2); 
      canvas.drawPath(bodyPath, bodyPaint);

      // Rocket Nose & Fins (Faded Red)
      final accentPaint = Paint()..color = Colors.redAccent.withValues(alpha: opacity);
      
      final nosePath = Path();
      nosePath.moveTo(0, -rSize * 1.2);
      nosePath.quadraticBezierTo(rSize * 0.25, -rSize * 0.95, rSize * 0.3, -rSize * 0.7);
      nosePath.lineTo(-rSize * 0.3, -rSize * 0.7);
      nosePath.quadraticBezierTo(-rSize * 0.25, -rSize * 0.95, 0, -rSize * 1.2);
      canvas.drawPath(nosePath, accentPaint);

      final finPath = Path();
      finPath.moveTo(-rSize * 0.4, rSize * 0.3);
      finPath.lineTo(-rSize * 0.7, rSize * 0.9);
      finPath.lineTo(-rSize * 0.4, rSize * 0.8);
      finPath.moveTo(rSize * 0.4, rSize * 0.3);
      finPath.lineTo(rSize * 0.7, rSize * 0.9);
      finPath.lineTo(rSize * 0.4, rSize * 0.8);
      canvas.drawPath(finPath, accentPaint);

      // Window (Faded Blue)
      canvas.drawCircle(Offset(0, -rSize * 0.1), rSize * 0.2, Paint()..color = Colors.lightBlueAccent.withValues(alpha: opacity));

      // Thruster Flame (Faded flickering)
      double flicker = 0.8 + 0.4 * sin(animationValue * pi * 20);
      final flamePaint = Paint()..color = Colors.orangeAccent.withValues(alpha: opacity * 1.2);
      final flamePath = Path();
      flamePath.moveTo(-rSize * 0.2, rSize * 0.8);
      flamePath.lineTo(0, rSize * (0.8 + 0.6 * flicker));
      flamePath.lineTo(rSize * 0.2, rSize * 0.8);
      canvas.drawPath(flamePath, flamePaint);
      
      canvas.drawCircle(Offset(0, rSize * 0.85), rSize * 0.3 * flicker, Paint()
        ..color = Colors.orange.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));

      canvas.restore();
    }

    // 2. Draw Stars (Drawn last so they stay on top)
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
  bool shouldRepaint(covariant CombinedBackgroundPainter oldDelegate) => true;
}
