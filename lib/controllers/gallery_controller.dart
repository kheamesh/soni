import 'package:get/get.dart';

class GalleryController extends GetxController {
  final Map<String, RxBool> _hoverMap = {};

  RxBool isHovered(String id) {
    return _hoverMap.putIfAbsent(id, () => false.obs);
  }

  void setHovered(String id, bool value) {
    isHovered(id).value = value;
  }
}
