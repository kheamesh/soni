import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class TechCornerPainter extends CustomPainter {
  final Color color;
  TechCornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double cornerSize = 20;

    // Top Left
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerSize)
        ..lineTo(0, 0)
        ..lineTo(cornerSize, 0),
      paint,
    );

    // Top Right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerSize, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, cornerSize),
      paint,
    );

    // Bottom Left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerSize)
        ..lineTo(0, size.height)
        ..lineTo(cornerSize, size.height),
      paint,
    );

    // Bottom Right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerSize, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, size.height - cornerSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class GridPainter extends CustomPainter {
  final double spacing;
  GridPainter({this.spacing = 30});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 0.5;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Floating HUD brackets that expand and fade when hovered.
class HUDBracketPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  HUDBracketPainter({required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.8 * (1 - animationValue))
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final double padding = 30 * animationValue;
    final double bracketSize = 25;

    final rect = Rect.fromLTWH(
      -padding,
      -padding,
      size.width + padding * 2,
      size.height + padding * 2,
    );

    // Top Left
    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.top + bracketSize)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.left + bracketSize, rect.top),
      paint,
    );

    // Top Right
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - bracketSize, rect.top)
        ..lineTo(rect.right, rect.top)
        ..lineTo(rect.right, rect.top + bracketSize),
      paint,
    );

    // Bottom Left
    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.bottom - bracketSize)
        ..lineTo(rect.left, rect.bottom)
        ..lineTo(rect.left + bracketSize, rect.bottom),
      paint,
    );

    // Bottom Right
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - bracketSize, rect.bottom)
        ..lineTo(rect.right, rect.bottom)
        ..lineTo(rect.right, rect.bottom - bracketSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
