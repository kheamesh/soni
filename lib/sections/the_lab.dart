import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_strings.dart';
import '../controllers/lab_controller.dart';

class TheLab extends StatelessWidget {
  const TheLab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LabController());
    
    return Container(
      height: 700,
      width: double.infinity,
      padding: const EdgeInsets.all(50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.labTitle,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 24, letterSpacing: 5),
          ),
          const SizedBox(height: 20),
          const Text(
            AppStrings.labSubtitle,
            style: TextStyle(color: Colors.white38, fontSize: 12, letterSpacing: 2),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white12),
                color: Colors.white.withValues(alpha: 0.02),
              ),
              child: Obx(() => Stack(
                children: List.generate(controller.objects.length, (index) {
                  final obj = controller.objects[index];
                  return Positioned(
                    left: obj.position.dx,
                    top: obj.position.dy,
                    child: GestureDetector(
                      onPanStart: (_) => controller.startDragging(index),
                      onPanUpdate: (details) => controller.updatePosition(index, details.delta),
                      onPanEnd: (_) => controller.endDragging(index),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: obj.color),
                          boxShadow: [
                            BoxShadow(color: obj.color.withValues(alpha: 0.3), blurRadius: 15)
                          ],
                        ),
                        child: Center(
                          child: FlutterLogo(size: 30, textColor: obj.color),
                        ),
                      ),
                    ),
                  );
                }),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
