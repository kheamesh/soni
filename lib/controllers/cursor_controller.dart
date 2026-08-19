import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_strings.dart';

class CursorController extends GetxController {
  var isHovering = false.obs;
  var hoverText = AppStrings.open.obs;
  var pointerPos = Offset.zero.obs;

  void setHovering(bool hovering, {String text = AppStrings.open}) {
    isHovering.value = hovering;
    hoverText.value = text;
  }

  void updatePointerPos(Offset pos) {
    pointerPos.value = pos;
  }
}
