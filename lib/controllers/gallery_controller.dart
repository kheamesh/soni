import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryController extends GetxController {
  final Map<String, RxBool> _hoverMap = {};
  final Map<String, Rx<Offset>> _tiltMap = {};

  RxBool isHovered(String id) {
    return _hoverMap.putIfAbsent(id, () => false.obs);
  }

  Rx<Offset> getTilt(String id) {
    return _tiltMap.putIfAbsent(id, () => Offset.zero.obs);
  }

  void setHovered(String id, bool value) {
    isHovered(id).value = value;
    if (!value) {
      getTilt(id).value = Offset.zero;
    }
  }

  void updateTilt(String id, Offset localPos, double width, double height) {
    getTilt(id).value = Offset(
      (localPos.dx - width / 2) / (width / 2),
      (localPos.dy - height / 2) / (height / 2),
    );
  }
}
