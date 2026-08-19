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
  final List<SpaceShip> _ships = [];
  final int _starCount = 2000;
  final int _shipCount = 8;

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

    for (int i = 0; i < _shipCount; i++) {
      _ships.add(SpaceShip());
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
          for (var ship in _ships) {
            ship.update(_controller.value);
          }
          return CustomPaint(
            painter: CombinedBackgroundPainter(
              stars: _particles,
              ships: _ships,
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

class SpaceShip {
  late Offset position;
  late double speed;
  late double size;
  late double floatOffset;
  final Random _random = Random();

  SpaceShip() {
    _reset();
    position = Offset(_random.nextDouble() * 2500, position.dy);
  }

  void _reset() {
    position = Offset(-200, _random.nextDouble() * 2500);
    speed = _random.nextDouble() * 3.0 + 2.0;
    size = _random.nextDouble() * 15 + 10;
    floatOffset = _random.nextDouble() * pi * 2;
  }

  void update(double anim) {
    // Forward movement
    position += Offset(speed, 0);
    
    // Smooth vertical floating
    double verticalBob = sin(anim * pi * 2 + floatOffset) * 2.0;
    position += Offset(0, verticalBob);

    if (position.dx > 2600) {
      _reset();
    }
  }
}

class CombinedBackgroundPainter extends CustomPainter {
  final List<StarParticle> stars;
  final List<SpaceShip> ships;
  final Offset mousePos;
  final double animationValue;

  CombinedBackgroundPainter({
    required this.stars,
    required this.ships,
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

    // 1. Draw Stars
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

    // 2. Draw Space Ships (High Fidelity Vector Art)
    final shipBodyPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    
    final wingPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final thrusterPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final engineGlow = Paint()
      ..style = PaintingStyle.fill;

    for (var ship in ships) {
      canvas.save();
      canvas.translate(ship.position.dx, ship.position.dy);

      // --- Draw Wings ---
      final wings = Path();
      wings.moveTo(-ship.size * 0.5, -ship.size * 0.6); // Top wing tip
      wings.lineTo(ship.size * 0.2, 0);
      wings.lineTo(-ship.size * 0.5, ship.size * 0.6); // Bottom wing tip
      wings.lineTo(-ship.size * 0.2, 0);
      wings.close();
      canvas.drawPath(wings, wingPaint);

      // --- Draw Main Body (Sleek aerodynamic shape) ---
      final body = Path();
      body.moveTo(ship.size * 0.8, 0); // Nose
      body.lineTo(-ship.size * 0.6, -ship.size * 0.25); // Top back
      body.lineTo(-ship.size * 0.8, 0); // Center back
      body.lineTo(-ship.size * 0.6, ship.size * 0.25); // Bottom back
      body.close();
      
      // Body Shadow/Depth
      canvas.drawPath(body, Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
      canvas.drawPath(body, shipBodyPaint);

      // --- Draw Cockpit ---
      final cockpit = Path();
      cockpit.moveTo(ship.size * 0.4, 0);
      cockpit.lineTo(ship.size * 0.1, -ship.size * 0.1);
      cockpit.lineTo(-ship.size * 0.1, 0);
      cockpit.lineTo(ship.size * 0.1, ship.size * 0.1);
      cockpit.close();
      canvas.drawPath(cockpit, Paint()..color = Colors.white.withValues(alpha: 0.4));

      // --- Animated Thruster Flame ---
      double flameScale = 0.8 + 0.4 * sin(animationValue * pi * 10); // Rapid flickering
      final flame = Path();
      flame.moveTo(-ship.size * 0.8, 0);
      flame.lineTo(-ship.size * (1.2 + 0.5 * flameScale), -ship.size * 0.15);
      flame.lineTo(-ship.size * (1.0 + 0.2 * flameScale), 0);
      flame.lineTo(-ship.size * (1.2 + 0.5 * flameScale), ship.size * 0.15);
      flame.close();

      engineGlow.color = AppColors.accent.withValues(alpha: 0.4);
      engineGlow.maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(Offset(-ship.size * 0.8, 0), ship.size * 0.4 * flameScale, engineGlow);
      
      canvas.drawPath(flame, thrusterPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CombinedBackgroundPainter oldDelegate) => true;
}
