import 'dart:async';
import 'package:get/get.dart';
import '../core/app_strings.dart';

class FooterController extends GetxController {
  final RxList<String> logs = <String>[].obs;
  final List<String> _possibleLogs = [
    AppStrings.terminalReady,
    AppStrings.terminalSync,
    AppStrings.terminalLab,
    "[SYSTEM] RE-RENDERING STARS...",
    "[UPLINK] SCANNING FOR PROJECTS...",
    "[CORE] OPTIMIZING DART PERFORMANCE...",
    "[DEBUG] MEMORY STABLE AT 60FPS",
    "[LAB] DRAG_PHYSICS_V4.0 ACTIVE",
  ];

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTerminal();
  }

  void _startTerminal() {
    // Add initial log
    logs.add(_possibleLogs[0]);

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (logs.length > 3) logs.removeAt(0);
      logs.add(_possibleLogs[timer.tick % _possibleLogs.length]);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
