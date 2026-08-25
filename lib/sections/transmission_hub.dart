import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'dart:math';
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

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? Get.height * 0.1 : Get.height * 0.15,
        horizontal: isMobile ? Get.width * 0.05 : Get.width * 0.04,
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Binary data streams layer
          Obx(
            () => AnimatedOpacity(
              opacity: controller.isTransmitting ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                width: double.infinity,
                height: Get.height * 0.8,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: controller.isTransmitting
                      ? List.generate(
                          isMobile ? 10 : 20,
                          (index) => _buildBinaryStream(index),
                        )
                      : [],
                ),
              ),
            ),
          ),

          Column(
            children: [
              // Connection Nodes Visualizer
              _buildConnectionNodes(isMobile),

              SizedBox(height: Get.height * 0.02),

              Obx(() {
                final transmitting = controller.isTransmitting;
                return Text(
                      AppStrings.transmissionTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary.withValues(alpha: 0.9),
                        fontSize: isMobile
                            ? Get.width * 0.06
                            : Get.width * 0.025,
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

              SizedBox(height: Get.height * 0.06),

              // Main Responsive Layout
              Container(
                constraints: BoxConstraints(maxWidth: Get.width * 0.8),
                child: Responsive(
                  mobile: Column(
                    children: [
                      _buildRightSide(controller, isMobile),
                      SizedBox(height: Get.height * 0.06),
                      _buildLeftSide(isMobile),
                    ],
                  ),
                  desktop: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT SIDE: Attractive Animation & Protocols
                      Expanded(flex: 1, child: _buildLeftSide(false)),

                      SizedBox(width: Get.width * 0.05),

                      // RIGHT SIDE: Form Fields & Send Button
                      Expanded(
                        flex: 1,
                        child: _buildRightSide(controller, false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSide(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // High-Tech Signal Scanner Animation
        Center(child: _buildSignalScanner(isMobile)),

        SizedBox(height: Get.height * 0.06),

        Text(
          AppStrings.protocolSelect,
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.5),
            fontSize: isMobile ? 10 : 12,
            letterSpacing: 2,
            fontFamily: 'monospace',
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          spacing: 15,
          runSpacing: 15,
          children: [
            _buildOption(AppStrings.optionWeb, isMobile),
            _buildOption(AppStrings.optionMobile, isMobile),
            _buildOption(AppStrings.optionBeyond, isMobile),
          ],
        ),
      ],
    );
  }

  Widget _buildSignalScanner(bool isMobile) {
    final size = isMobile ? Get.width * 0.3 : Get.width * 0.12;
    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Rotating Ring
          Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              )
              .animate(onPlay: (c) => c.repeat())
              .rotate(duration: const Duration(seconds: 10)),

          // Inner Pulsing Glow
          Container(
                width: size * 0.6,
                height: size * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.1, 1.1),
                duration: const Duration(seconds: 2),
              ),

          // Technical Crosshair
          CustomPaint(size: Size(size, size), painter: CrosshairPainter())
              .animate(onPlay: (c) => c.repeat())
              .rotate(duration: const Duration(seconds: 4)),

          // Center Core
          Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .shimmer(
                duration: const Duration(seconds: 1),
                color: AppColors.primary,
              ),
        ],
      ),
    );
  }

  Widget _buildRightSide(TransmissionController controller, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        _buildTextField(
          AppStrings.labelName,
          AppStrings.hintEnterName,
          isMobile,
        ),
        SizedBox(height: Get.height * 0.02),
        _buildTextField(
          AppStrings.labelSurname,
          AppStrings.hintEnterSurname,
          isMobile,
        ),
        SizedBox(height: Get.height * 0.02),
        _buildTextField(
          AppStrings.labelEmail,
          AppStrings.hintEnterEmail,
          isMobile,
        ),
        SizedBox(height: Get.height * 0.02),
        _buildTextField(
          AppStrings.labelNotes,
          AppStrings.hintEnterNotes,
          isMobile,
          maxLines: 5,
        ),

        SizedBox(height: Get.height * 0.04),

        // SEND TRANSMISSION Button
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
                  horizontal: isMobile ? Get.width * 0.05 : Get.width * 0.03,
                  vertical: Get.height * 0.02,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: controller.isTransmitting
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  border: Border.all(
                    color: controller.isTransmitting
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.2),
                  ),
                  boxShadow: controller.isTransmitting
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 20,
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  controller.isTransmitting
                      ? AppStrings.uplinkActive
                      : AppStrings.sendTransmission,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: controller.isTransmitting
                        ? AppColors.primary
                        : AppColors.textPrimary.withValues(alpha: 0.7),
                    letterSpacing: 5,
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
    );
  }

  Widget _buildConnectionNodes(bool isMobile) {
    return SizedBox(
      height: isMobile ? Get.height * 0.12 : Get.height * 0.18,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(4, (index) {
          final angle = (index * 2 * pi) / 4;
          final radiusBegin = isMobile ? Get.width * 0.12 : Get.width * 0.06;
          final radiusEnd = isMobile ? Get.width * 0.04 : Get.width * 0.02;

          return Positioned(
            child:
                Container(
                      width: isMobile ? 8 : 10,
                      height: isMobile ? 8 : 10,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .move(
                      begin: Offset(
                        cos(angle) * radiusBegin,
                        sin(angle) * radiusBegin,
                      ),
                      end: Offset(
                        cos(angle) * radiusEnd,
                        sin(angle) * radiusEnd,
                      ),
                      duration: Duration(seconds: 1 + index),
                      curve: Curves.easeInOut,
                    )
                    .shimmer(color: Colors.white),
          );
        }),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    bool isMobile, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.primary.withValues(alpha: 0.6),
            fontSize: isMobile ? 9 : 10,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textPrimary.withValues(alpha: 0.1),
              fontSize: 12,
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.02),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.02,
              vertical: Get.height * 0.015,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBinaryStream(int index) {
    final random = (index * 739) % 1000;
    final xPos = (random / 1000) * Get.width - (Get.width / 2);
    final binary = (index % 2 == 0) ? AppStrings.binary1 : AppStrings.binary2;

    return Transform.translate(
      offset: Offset(xPos, Get.height * 0.4),
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
                end: -Get.height * 0.8,
                duration: Duration(milliseconds: 1000 + (random % 2000)),
                curve: Curves.easeInCirc,
              )
              .fadeOut(delay: const Duration(milliseconds: 500)),
    );
  }

  Widget _buildOption(String text, bool isMobile) {
    return CursorHoverRegion(
      text: AppStrings.selectLabel,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? Get.width * 0.05 : Get.width * 0.02,
          vertical: Get.height * 0.015,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            letterSpacing: 2,
            fontSize: isMobile ? 12 : 14,
          ),
        ),
      ),
    );
  }
}

class CrosshairPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw 4 segments of a ring
    for (int i = 0; i < 4; i++) {
      final startAngle = (i * pi / 2) + (pi / 8);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        pi / 4,
        false,
        paint,
      );
    }

    // Small interior dashes
    paint.strokeWidth = 0.5;
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final inner =
          center +
          Offset(cos(angle) * (radius - 15), sin(angle) * (radius - 15));
      final outer =
          center + Offset(cos(angle) * (radius - 5), sin(angle) * (radius - 5));
      canvas.drawLine(inner, outer, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
