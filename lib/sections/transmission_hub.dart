import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../widgets/custom_cursor.dart';
import '../controllers/transmission_controller.dart';

class TransmissionHub extends StatelessWidget {
  const TransmissionHub({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransmissionController());
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 50),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Binary data streams layer - persistent but conditionally visible
          Obx(() => AnimatedOpacity(
            opacity: controller.isTransmitting ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: SizedBox(
              width: double.infinity,
              height: 800,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: controller.isTransmitting 
                  ? List.generate(20, (index) => _buildBinaryStream(index))
                  : [],
              ),
            ),
          )),

          Column(
            children: [
              Obx(() {
                // Access value to trigger rebuild
                final transmitting = controller.isTransmitting;
                return Text(
                  AppStrings.transmissionTitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9), 
                    fontSize: 40, 
                    fontWeight: FontWeight.w900, 
                    letterSpacing: 5,
                    shadows: [
                      Shadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 20),
                    ]
                  ),
                ).animate(target: transmitting ? 1 : 0)
                 .shake(hz: 4, duration: const Duration(milliseconds: 200));
              }),
              
              const SizedBox(height: 50),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOption(AppStrings.optionWeb),
                  const SizedBox(width: 20),
                  _buildOption(AppStrings.optionMobile),
                  const SizedBox(width: 20),
                  _buildOption(AppStrings.optionBeyond),
                ],
              ),
              
              const SizedBox(height: 80),
              
              GestureDetector(
                onTap: controller.startTransmission,
                child: Obx(() => CursorHoverRegion(
                  text: controller.isTransmitting ? AppStrings.uplinking : AppStrings.transmit,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    decoration: BoxDecoration(
                      color: controller.isTransmitting ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                      border: Border.all(color: controller.isTransmitting ? AppColors.primary : Colors.white24),
                      boxShadow: controller.isTransmitting ? [
                        BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 20)
                      ] : [],
                    ),
                    child: Text(
                      controller.isTransmitting ? AppStrings.uplinkActive : AppStrings.sendTransmission,
                      style: TextStyle(
                        color: controller.isTransmitting ? AppColors.primary : Colors.white70, 
                        letterSpacing: 5,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBinaryStream(int index) {
    final random = (index * 739) % 1000;
    final xPos = (random / 1000) * 800 - 400;
    final binary = (index % 2 == 0) ? AppStrings.binary1 : AppStrings.binary2;
    
    return Transform.translate(
      offset: Offset(xPos, 400), // Start from bottom
      child: Text(
        binary,
        style: TextStyle(
          color: AppColors.primary.withValues(alpha: 0.5),
          fontSize: 10,
          fontFamily: 'monospace',
        ),
      )
      .animate()
      .moveY(begin: 0, end: -800, duration: Duration(milliseconds: 1000 + (random % 2000)), curve: Curves.easeInCirc)
      .fadeOut(delay: const Duration(milliseconds: 500)),
    );
  }

  Widget _buildOption(String text) {
    return CursorHoverRegion(
      text: "SELECT",
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white12),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white54, letterSpacing: 2)),
      ),
    );
  }
}
