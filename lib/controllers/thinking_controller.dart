import 'package:get/get.dart';

class ThinkingController extends GetxController {
  final Map<String, RxBool> _revealedMap = {};
  final Map<String, RxBool> _glitchedMap = {};

  RxBool isRevealed(String id) {
    return _revealedMap.putIfAbsent(id, () => false.obs);
  }

  RxBool isGlitched(String id) {
    return _glitchedMap.putIfAbsent(id, () => false.obs);
  }

  void toggleRevealed(String id) {
    final revealed = isRevealed(id);
    revealed.value = true;
  }

  void toggleGlitched(String id) {
    final glitched = isGlitched(id);
    glitched.value = !glitched.value;
  }
}
