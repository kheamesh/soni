import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';

class LabController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController physicsController;
  final RxList<PhysicsObject> objects = <PhysicsObject>[].obs;
  final RxList<Offset> nanoBots = <Offset>[].obs;
  final Random _random = Random();
  
  double _maxWidth = 1000.0;
  double _maxHeight = 600.0;

  @override
  void onInit() {
    super.onInit();
    physicsController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    physicsController.addListener(_updatePhysics);
    
    final techData = [
      {'icon': Icons.flutter_dash, 'name': 'Flutter'},
      {'icon': Icons.terminal, 'name': 'Dart'},
      {'icon': Icons.storage, 'name': 'Firebase'},
      {'icon': Icons.android, 'name': 'Android'},
      {'icon': Icons.apple, 'name': 'iOS'},
      {'icon': Icons.code, 'name': 'CleanCode'},
      {'icon': Icons.hub, 'name': 'Git'},
      {'icon': Icons.memory, 'name': 'Logic'},
      {'icon': Icons.security, 'name': 'Auth'},
      {'icon': Icons.speed, 'name': 'Perf'},
    ];

    for (int i = 0; i < techData.length; i++) {
      objects.add(PhysicsObject(
        position: Offset(100.0 + (i % 5) * 150.0, 100.0 + (i / 5) * 150.0),
        velocity: Offset(_random.nextDouble() * 6 - 3, _random.nextDouble() * 6 - 3),
        color: i % 3 == 0 ? AppColors.primary : (i % 3 == 1 ? AppColors.secondary : AppColors.accent),
        icon: techData[i]['icon'] as IconData,
        mass: 1.0 + _random.nextDouble() * 1.5,
        rotation: _random.nextDouble() * pi * 2,
        angularVelocity: (_random.nextDouble() - 0.5) * 0.2,
      ));
    }

    for (int i = 0; i < 40; i++) {
      nanoBots.add(Offset(_random.nextDouble() * 1000, _random.nextDouble() * 800));
    }
  }

  void updateBounds(double width, double height) {
    _maxWidth = width;
    _maxHeight = height;
  }

  void updateMousePos(Offset pos) {
    for (var obj in objects) {
      if (obj.isDragging) continue;
      double dist = (obj.position - pos).distance;
      if (dist < 200) {
        Offset force = (pos - obj.position) / dist;
        obj.velocity += force * 0.4;
      }
    }
  }

  void _updatePhysics() {
    const gravity = 0.35;
    const friction = 0.985;
    const bounce = -0.7;
    
    for (int i = 0; i < objects.length; i++) {
      var obj = objects[i];
      if (obj.isDragging) continue;

      // 1. Movement & Rotation
      obj.velocity = Offset(obj.velocity.dx * friction, obj.velocity.dy + (gravity * obj.mass));
      obj.position += obj.velocity;
      obj.rotation += obj.angularVelocity;
      obj.angularVelocity *= 0.99; // Air resistance for spin

      // 2. Wall Collisions with Rotation effect
      final size = 60.0 * (obj.mass / 2 + 0.5);
      if (obj.position.dy > _maxHeight - size) {
        obj.position = Offset(obj.position.dx, _maxHeight - size);
        obj.velocity = Offset(obj.velocity.dx, obj.velocity.dy * bounce);
        obj.angularVelocity += obj.velocity.dx * 0.05; // Hit floor makes it spin
      }
      if (obj.position.dx < 0) {
        obj.position = Offset(0, obj.position.dy);
        obj.velocity = Offset(obj.velocity.dx * bounce, obj.velocity.dy);
        obj.angularVelocity += obj.velocity.dy * 0.05;
      } else if (obj.position.dx > _maxWidth - size) {
        obj.position = Offset(_maxWidth - size, obj.position.dy);
        obj.velocity = Offset(obj.velocity.dx * bounce, obj.velocity.dy);
        obj.angularVelocity -= obj.velocity.dy * 0.05;
      }

      // 3. Collision Logic
      for (int j = i + 1; j < objects.length; j++) {
        var other = objects[j];
        double dist = (obj.position - other.position).distance;
        double minDistance = 60.0;
        
        if (dist < minDistance) {
          Offset normal = (obj.position - other.position) / dist;
          Offset relativeVelocity = obj.velocity - other.velocity;
          double velocityAlongNormal = relativeVelocity.dx * normal.dx + relativeVelocity.dy * normal.dy;
          if (velocityAlongNormal > 0) continue;

          double e = 0.8;
          double jScalar = -(1 + e) * velocityAlongNormal;
          jScalar /= (1 / obj.mass + 1 / other.mass);

          Offset impulse = normal * jScalar;
          obj.velocity += impulse / obj.mass;
          other.velocity -= impulse / other.mass;
          
          obj.impactPulse = 1.0;
          other.impactPulse = 1.0;
          
          // Collision adds spin
          obj.angularVelocity += 0.1;
          other.angularVelocity -= 0.1;
        }
      }
      if (obj.impactPulse > 0) obj.impactPulse -= 0.1;
    }

    for (int i = 0; i < nanoBots.length; i++) {
      nanoBots[i] += Offset(_random.nextDouble() * 2 - 1, _random.nextDouble() * 2 - 1);
    }
    
    objects.refresh();
  }

  void startDragging(int index) {
    objects[index].isDragging = true;
    objects[index].velocity = Offset.zero;
    objects[index].angularVelocity = 0;
  }

  void updatePosition(int index, Offset delta) {
    objects[index].position += delta;
    objects[index].velocity = delta * 2.5;
    objects[index].angularVelocity = delta.dx * 0.05; // Dragging speed affects spin
    objects.refresh();
  }

  void endDragging(int index) {
    objects[index].isDragging = false;
  }

  @override
  void onClose() {
    physicsController.dispose();
    super.onClose();
  }
}

class PhysicsObject {
  Offset position;
  Offset velocity;
  bool isDragging;
  Color color;
  IconData icon;
  double mass;
  double rotation;
  double angularVelocity;
  double impactPulse = 0.0;

  PhysicsObject({
    required this.position,
    required this.velocity,
    this.isDragging = false,
    required this.color,
    required this.icon,
    required this.mass,
    required this.rotation,
    required this.angularVelocity,
  });
}
