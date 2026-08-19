import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../widgets/custom_cursor.dart';
import '../utils/responsive.dart';
import '../controllers/transmission_controller.dart';

class TransmissionHub extends StatelessWidget {
  const TransmissionHub({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransmissionController());
    final isMobile = Responsive.isMobile(context);
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 80 : 150, horizontal: isMobile ? 20 : 50),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Binary data streams layer - persistent but conditionally visible
          Obx(
            () => AnimatedOpacity(
              opacity: controller.isTransmitting ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                width: double.infinity,
                height: isMobile ? 500 : 800,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: controller.isTransmitting
                      ? List.generate(isMobile ? 10 : 20, (index) => _buildBinaryStream(index, size.width))
                      : [],
                ),
              ),
            ),
          ),

          Column(
            children: [
              Obx(() {
                final transmitting = controller.isTransmitting;
                return Text(
                      AppStrings.transmissionTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: isMobile ? 24 : 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: isMobile ? 2 : 5,
                        shadows: [
                          Shadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    )
                    .animate(target: transmitting ? 1 : 0)
                    .shake(hz: 4, duration: const Duration(milliseconds: 200));
              }),

              const SizedBox(height: 50),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 15,
                runSpacing: 15,
                children: [
                  _buildOption(AppStrings.optionWeb, isMobile),
                  _buildOption(AppStrings.optionMobile, isMobile),
                  _buildOption(AppStrings.optionBeyond, isMobile),
                ],
              ),

              const SizedBox(height: 60),

              GestureDetector(
                onTap: controller.startTransmission,
                child: Obx(
                  () => CursorHoverRegion(
                    text: controller.isTransmitting
                        ? AppStrings.uplinking
                        : AppStrings.transmit,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 25 : 40,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: controller.isTransmitting
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color: controller.isTransmitting
                              ? AppColors.primary
                              : Colors.white24,
                        ),
                        boxShadow: controller.isTransmitting
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 20,
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        controller.isTransmitting
                            ? AppStrings.uplinkActive
                            : AppStrings.sendTransmission,
                        style: TextStyle(
                          color: controller.isTransmitting
                              ? AppColors.primary
                              : Colors.white70,
                          letterSpacing: isMobile ? 2 : 5,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 12 : 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBinaryStream(int index, double screenWidth) {
    final random = (index * 739) % 1000;
    final xPos = (random / 1000) * screenWidth - (screenWidth / 2);
    final binary = (index % 2 == 0) ? AppStrings.binary1 : AppStrings.binary2;

    return Transform.translate(
      offset: Offset(xPos, 400), // Start from bottom
      child:
          Text(
                binary,
                style: TextStyle(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              )
              .animate()
              .moveY(
                begin: 0,
                end: -800,
                duration: Duration(milliseconds: 1000 + (random % 2000)),
                curve: Curves.easeInCirc,
              )
              .fadeOut(delay: const Duration(milliseconds: 500)),
    );
  }

  Widget _buildOption(String text, bool isMobile) {
    return CursorHoverRegion(
      text: "SELECT",
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 30, vertical: 15),
        decoration: BoxDecoration(border: Border.all(color: Colors.white12)),
        child: Text(
          text,
          style: TextStyle(color: Colors.white54, letterSpacing: 2, fontSize: isMobile ? 12 : 14),
        ),
      ),
    );
  }
}
