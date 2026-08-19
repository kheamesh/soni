import 'package:get/get.dart';

class AppController extends GetxController {
  var isBooted = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startBootSequence();
  }

  void _startBootSequence() {
    Future.delayed(const Duration(seconds: 3), () {
      isBooted.value = true;
    });
  }
}
