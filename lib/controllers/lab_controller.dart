import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';

class LabController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController physicsController;
  final RxList<PhysicsObject> objects = <PhysicsObject>[].obs;
  final Random _random = Random();

  @override
  void onInit() {
    super.onInit();
    physicsController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    physicsController.addListener(_updatePhysics);
    
    // Initialize objects
    for (int i = 0; i < 5; i++) {
      objects.add(PhysicsObject(
        position: Offset(100.0 + i * 150.0, 100.0),
        velocity: Offset(_random.nextDouble() * 2 - 1, 0),
        color: i % 2 == 0 ? AppColors.primary : AppColors.secondary,
      ));
    }
  }

  void _updatePhysics() {
    const gravity = 0.5;
    const friction = 0.98;
    const bounce = -0.7;
    
    const floorY = 600.0;
    const wallRight = 1000.0;
    const wallLeft = 50.0;

    for (var obj in objects) {
      if (obj.isDragging) continue;

      obj.velocity = Offset(obj.velocity.dx * friction, obj.velocity.dy + gravity);
      obj.position += obj.velocity;

      if (obj.position.dy > floorY - 50) {
        obj.position = Offset(obj.position.dx, floorY - 50);
        obj.velocity = Offset(obj.velocity.dx, obj.velocity.dy * bounce);
      }

      if (obj.position.dx < wallLeft) {
        obj.position = Offset(wallLeft, obj.position.dy);
        obj.velocity = Offset(obj.velocity.dx * bounce, obj.velocity.dy);
      } else if (obj.position.dx > wallRight - 50) {
        obj.position = Offset(wallRight - 50, obj.position.dy);
        obj.velocity = Offset(obj.velocity.dx * bounce, obj.velocity.dy);
      }
    }
    objects.refresh();
  }

  void startDragging(int index) {
    objects[index].isDragging = true;
  }

  void updatePosition(int index, Offset delta) {
    objects[index].position += delta;
    objects[index].velocity = delta;
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

  PhysicsObject({
    required this.position,
    required this.velocity,
    this.isDragging = false,
    required this.color,
  });
}
