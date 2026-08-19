import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavController extends GetxController {
  final ScrollController scrollController = ScrollController();
  
  final GlobalKey heroKey = GlobalKey();
  final GlobalKey workKey = GlobalKey();
  final GlobalKey craftKey = GlobalKey();
  final GlobalKey thinkingKey = GlobalKey();
  final GlobalKey labKey = GlobalKey();
  final GlobalKey codeKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOutQuart,
      );
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
