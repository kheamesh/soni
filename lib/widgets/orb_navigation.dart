import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_colors.dart';
import 'custom_cursor.dart';

class OrbNavigation extends StatefulWidget {
  final Function(String)? onItemSelected;
  const OrbNavigation({super.key, this.onItemSelected});

  @override
  State<OrbNavigation> createState() => _OrbNavigationState();
}

class _OrbNavigationState extends State<OrbNavigation> {
  bool _isExpanded = false;
  Offset _orbPosition = const Offset(100, 100);

  final List<Map<String, dynamic>> _menuItems = [
    {'label': 'ME', 'icon': Icons.person},
    {'label': 'WORK', 'icon': Icons.work},
    {'label': 'CRAFT', 'icon': Icons.brush},
    {'label': 'LAB', 'icon': Icons.science},
    {'label': 'CODE', 'icon': Icons.code},
    {'label': 'CONTACT', 'icon': Icons.send},
  ];

  void _handleDrag(Offset delta, Size size) {
    setState(() {
      Offset newPos = _orbPosition + delta;
      
      // Magnetic/Resistive effect near edges
      const margin = 100.0;
      double resistance = 1.0;
      
      if (newPos.dx < margin || newPos.dx > size.width - margin) resistance = 0.3;
      if (newPos.dy < margin || newPos.dy > size.height - margin) resistance = 0.3;
      
      _orbPosition += delta * resistance;

      // Hard clamp to keep it on screen
      _orbPosition = Offset(
        _orbPosition.dx.clamp(40, size.width - 40),
        _orbPosition.dy.clamp(40, size.height - 40),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        if (_isExpanded)
          ...List.generate(_menuItems.length, (index) {
            final angle = (index * 2 * pi) / _menuItems.length;
            const radius = 120.0;
            return Positioned(
              left: _orbPosition.dx + cos(angle) * radius - 25,
              top: _orbPosition.dy + sin(angle) * radius - 25,
              child: GestureDetector(
                onTap: () {
                  widget.onItemSelected?.call(_menuItems[index]['label']);
                  setState(() => _isExpanded = false);
                },
                child: CursorHoverRegion(
                  text: "GO",
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withValues(alpha: 0.8),
                          border: Border.all(color: AppColors.primary, width: 1),
                        ),
                        child: Icon(_menuItems[index]['icon'], color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _menuItems[index]['label'],
                        style: const TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 2),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 300.ms).scale(delay: (index * 50).ms),
              ),
            );
          }),
        Positioned(
          left: _orbPosition.dx - 40,
          top: _orbPosition.dy - 40,
          child: GestureDetector(
            onPanUpdate: (details) => _handleDrag(details.delta, size),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: CursorHoverRegion(
              text: _isExpanded ? "CLOSE" : "MENU",
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.6),
                      Colors.blueAccent.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
            ),
          ),
        ),
      ],
    );
  }
}
