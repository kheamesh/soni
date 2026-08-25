import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_strings.dart';
import '../core/app_colors.dart';
import '../utils/responsive.dart';
import '../controllers/lab_controller.dart';
import '../widgets/custom_cursor.dart';

class TheLab extends StatelessWidget {
  const TheLab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LabController());
    final isMobile = Responsive.isMobile(context);

    return Container(
      height: isMobile ? 700 : 900,
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.labTitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: isMobile ? 18 : 24,
              letterSpacing: isMobile ? 2 : 5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.engineeringLab,
            style: TextStyle(
              color: Colors.white38,
              fontSize: isMobile ? 10 : 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                controller.updateBounds(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );

                return MouseRegion(
                  onHover: (e) => controller.updateMousePos(e.localPosition),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.02),
                      // Translucent background to show global stars
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 40,
                          spreadRadius: -10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          // Background Grid Lines
                          _buildGridLines(),

                          // Background Nano-Bots and Energy Links
                          Obx(() {
                            final objects = controller.objects.toList();
                            final nanoBots = controller.nanoBots.toList();
                            return CustomPaint(
                              painter: LabEnvironmentPainter(
                                objects: objects,
                                nanoBots: nanoBots,
                              ),
                              size: Size.infinite,
                            );
                          }),

                          // The Physics Objects (Icons)
                          Obx(() {
                            final objectCount = controller.objects.length;
                            return Stack(
                              children: List.generate(objectCount, (index) {
                                final obj = controller.objects[index];
                                final size =
                                    (isMobile ? 40.0 : 60.0) *
                                    (obj.mass / 2 + 0.5);

                                return Positioned(
                                  left: obj.position.dx,
                                  top: obj.position.dy,
                                  child: GestureDetector(
                                    onPanStart: (_) =>
                                        controller.startDragging(index),
                                    onPanUpdate: (details) => controller
                                        .updatePosition(index, details.delta),
                                    onPanEnd: (_) =>
                                        controller.endDragging(index),
                                    child: Transform.rotate(
                                      angle: obj.rotation,
                                      child: CursorHoverRegion(
                                        text: AppStrings.grab,
                                        child: Container(
                                          width: size,
                                          height: size,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(
                                              alpha: 0.8,
                                            ),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color.lerp(
                                                obj.color,
                                                Colors.white,
                                                obj.impactPulse,
                                              )!,
                                              width: 2 + (obj.impactPulse * 4),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: obj.color.withValues(
                                                  alpha: 0.4,
                                                ),
                                                blurRadius:
                                                    15 + (obj.impactPulse * 20),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Icon(
                                              obj.icon,
                                              color: obj.color,
                                              size: size * 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          }),

                          // Corner Markers (The Box feel)
                          _buildCornerMarker(top: 10, left: 10),
                          _buildCornerMarker(top: 10, right: 10),
                          _buildCornerMarker(bottom: 10, left: 10),
                          _buildCornerMarker(bottom: 10, right: 10),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridLines() {
    return Positioned.fill(
      child: Opacity(opacity: 0.03, child: CustomPaint(painter: GridPainter())),
    );
  }

  Widget _buildCornerMarker({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          border: Border(
            top: top != null
                ? BorderSide(color: AppColors.primary, width: 2)
                : BorderSide.none,
            bottom: bottom != null
                ? BorderSide(color: AppColors.primary, width: 2)
                : BorderSide.none,
            left: left != null
                ? BorderSide(color: AppColors.primary, width: 2)
                : BorderSide.none,
            right: right != null
                ? BorderSide(color: AppColors.primary, width: 2)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LabEnvironmentPainter extends CustomPainter {
  final List<PhysicsObject> objects;
  final List<Offset> nanoBots;

  LabEnvironmentPainter({required this.objects, required this.nanoBots});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()..strokeWidth = 0.5;
    final botPaint = Paint()..color = Colors.white.withValues(alpha: 0.1);

    for (var bot in nanoBots) {
      canvas.drawCircle(bot, 0.8, botPaint);
    }

    for (int i = 0; i < objects.length; i++) {
      for (int j = i + 1; j < objects.length; j++) {
        double dist = (objects[i].position - objects[j].position).distance;
        if (dist < 180) {
          linePaint.color = objects[i].color.withValues(
            alpha: (1 - dist / 180) * 0.25,
          );
          canvas.drawLine(
            objects[i].position + const Offset(30, 30),
            objects[j].position + const Offset(30, 30),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
