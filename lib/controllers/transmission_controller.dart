import 'package:get/get.dart';

class TransmissionController extends GetxController {
  final _isTransmitting = false.obs;
  bool get isTransmitting => _isTransmitting.value;

  void startTransmission() {
    if (_isTransmitting.value) return; // Prevent multiple overlapping transmissions
    
    _isTransmitting.value = true;
    Future.delayed(const Duration(seconds: 4), () {
      _isTransmitting.value = false;
    });
  }
}
