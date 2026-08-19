import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConstellationController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  var hoverPos = Offset.zero.obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  void updateHoverPos(Offset pos) {
    hoverPos.value = pos;
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
