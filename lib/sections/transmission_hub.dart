// ignore_for_file: sized_box_for_whitespace

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
        vertical: isMobile ? Get.height * 0.1 : Get.height * 0.001,
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

              SizedBox(height: Get.height * 0.01),

              Obx(() {
                final transmitting = controller.isTransmitting;
                return Text(
                      AppStrings.transmissionTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: isMobile
                            ? Get.width * 0.08
                            : Get.width * 0.03,
                        fontWeight: FontWeight.w900,
                        letterSpacing: isMobile ? 4 : 8,
                        shadows: [
                          Shadow(
                            color: AppColors.primary,
                            blurRadius: 30,
                          ),
                          Shadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 10,
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
        // Neural Data Core Visualizer
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildNeuralCore(isMobile),
              if (!isMobile) _buildNeuralPath(isMobile),
            ],
          ),
        ),

        SizedBox(height: Get.height * 0.05),

        // Live Data Feed
        _buildLiveDataFeed(isMobile),

        SizedBox(height: Get.height * 0.04),

        Text(
          AppStrings.protocolSelect,
          style: TextStyle(
            color: AppColors.primary.withValues(alpha: 0.4),
            fontSize: isMobile ? 10 : 11,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2, end: 0),

        SizedBox(height: Get.height * 0.02),

        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildOption(AppStrings.optionWeb, isMobile, 0),
            _buildOption(AppStrings.optionMobile, isMobile, 1),
            _buildOption(AppStrings.optionBeyond, isMobile, 2),
          ],
        ),
      ],
    );
  }

  Widget _buildNeuralCore(bool isMobile) {
    final size = isMobile ? Get.width * 0.35 : Get.width * 0.15;
    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient Glow
          Container(
                width: size * 0.5,
                height: size * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 50,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.2, 1.2),
                duration: GetNumUtils(3).seconds,
              ),

          // Multiple Orbiting Data Paths
          ...List.generate(3, (i) {
            return Transform.rotate(
              angle: (i * pi) / 3,
              child:
                  Container(
                        width: size,
                        height: size * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(size, size * 0.3),
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            width: 0.5,
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat())
                      .rotate(duration: GetNumUtils(5 + i * 2).seconds),
            );
          }),

          // Data Nodes on Orbits
          ...List.generate(6, (i) {
            final angle = (i * 2 * pi) / 6;
            return _buildOrbitingNode(size, angle, i);
          }),

          // Central Neural Node
          Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.primary, blurRadius: 15),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
                duration: GetNumUtils(1).seconds,
                color: AppColors.primary,
              )
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
                duration: GetNumUtils(500).milliseconds,
                curve: Curves.easeInOut,
              ),

          // Technical Rings
          CustomPaint(
                size: Size(size * 0.8, size * 0.8),
                painter: TechnicalRingPainter(),
              )
              .animate(onPlay: (c) => c.repeat())
              .rotate(duration: GetNumUtils(8).seconds),
        ],
      ),
    );
  }

  Widget _buildOrbitingNode(double size, double angle, int i) {
    return Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .custom(
          duration: GetNumUtils(3 + i).seconds,
          builder: (context, value, child) {
            final currentAngle = angle + (value * 2 * pi);
            final x = cos(currentAngle) * (size / 2);
            final y = sin(currentAngle) * (size / 2) * 0.3; // Elliptical path
            return Transform.translate(offset: Offset(x, y), child: child);
          },
        )
        .shimmer(color: AppColors.white);
  }

  Widget _buildNeuralPath(bool isMobile) {
    final size = Get.width * 0.15;
    return CustomPaint(
          size: Size(size, size * 1.5),
          painter: NeuralPathPainter(
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: GetNumUtils(2).seconds,
          color: AppColors.primary.withValues(alpha: 0.4),
        );
  }

  Widget _buildLiveDataFeed(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.02),
        border: Border(left: BorderSide(color: AppColors.primary, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          _buildFeedLine(AppStrings.systConnected, 0),
          _buildFeedLine(AppStrings.coreOnline, 1),
          _buildFeedLine(AppStrings.dataStreaming, 2),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildFeedLine(String text, int index) {
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "> ",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 9,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.8),
                  fontSize: 11,
                  fontFamily: 'monospace',
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          delay: (index * 500).ms,
          duration: GetNumUtils(2).seconds,
          color: AppColors.primary.withValues(alpha: 0.2),
        );
  }

  Widget _buildRightSide(TransmissionController controller, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.insertInfo,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: isMobile ? 14 : 22,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ).animate().fadeIn().slideY(begin: 0.2, end: 0),
        SizedBox(height: Get.height * 0.03),
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
                      : AppColors.transparent,
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
                    .shimmer(color: AppColors.white),
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
            color: AppColors.primary,
            fontSize: isMobile ? 11 : 12,
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
              color: AppColors.textPrimary.withValues(alpha: 0.3),
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.white.withValues(alpha: 0.02),
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

  Widget _buildOption(String text, bool isMobile, int index) {
    return CursorHoverRegion(
      text: AppStrings.selectLabel,
      child:
          Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.03),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "[",
                      style: TextStyle(color: AppColors.primary, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      text,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 14 : 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "]",
                      style: TextStyle(color: AppColors.primary, fontSize: 14),
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .shimmer(
                duration: GetNumUtils(3).seconds,
                color: AppColors.primary.withValues(alpha: 0.2),
              )
              .animate()
              .fadeIn(
                duration: GetNumUtils(600).milliseconds,
                delay: GetNumUtils(200 * index).milliseconds,
              )
              .slideX(begin: -0.2, end: 0, curve: Curves.easeOutBack),
    );
  }
}

class NeuralPathPainter extends CustomPainter {
  final Color color;

  NeuralPathPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final startX = size.width / 2;
    final startY = size.height * 0.2;

    // Main downward trunk
    path.moveTo(startX, startY);
    path.lineTo(startX, size.height * 0.6);

    // Branching connections
    path.moveTo(startX, size.height * 0.6);
    path.lineTo(startX - 50, size.height * 0.9);
    path.lineTo(startX - 50, size.height);

    path.moveTo(startX, size.height * 0.6);
    path.lineTo(startX + 50, size.height * 0.9);
    path.lineTo(startX + 50, size.height);

    path.moveTo(startX, size.height * 0.6);
    path.lineTo(startX, size.height);

    canvas.drawPath(path, paint);

    // Draw small circles at joint points
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(startX, size.height * 0.6), 3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TechnicalRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw dashed ring
    for (int i = 0; i < 12; i++) {
      final startAngle = (i * 2 * pi) / 12;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        (2 * pi) / 24,
        false,
        paint,
      );
    }

    // Draw small degree markers
    paint.strokeWidth = 0.5;
    for (int i = 0; i < 36; i++) {
      final angle = (i * 2 * pi) / 36;
      final inner =
          center + Offset(cos(angle) * (radius - 5), sin(angle) * (radius - 5));
      final outer = center + Offset(cos(angle) * radius, sin(angle) * radius);
      canvas.drawLine(inner, outer, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
