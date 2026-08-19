import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../controllers/cursor_controller.dart';

class CustomCursor extends StatelessWidget {
  final Widget child;
  const CustomCursor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Disable custom cursor on mobile/tablet touch devices for better native feel
    final bool isMobileDevice = !kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
    final bool isWebMobile = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
    
    if (isMobileDevice || isWebMobile) return child;

    final controller = Get.put(CursorController());
    
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      opaque: false,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerHover: (event) => controller.updatePointerPos(event.position),
        onPointerMove: (event) => controller.updatePointerPos(event.position),
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            Obx(() {
              final pointerPos = controller.pointerPos.value;
              final isHovering = controller.isHovering.value;
              final text = controller.hoverText.value;
              
              return Positioned(
                left: pointerPos.dx - (isHovering ? 40 : 20),
                top: pointerPos.dy - (isHovering ? 40 : 20),
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isHovering ? 80 : 40,
                      height: isHovering ? 80 : 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.8),
                          width: 2,
                        ),
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                      child: Center(
                        child: Text(
                          isHovering ? text : "",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            Obx(() {
              final pointerPos = controller.pointerPos.value;
              return Positioned(
                left: pointerPos.dx - 2,
                top: pointerPos.dy - 2,
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class CursorHoverRegion extends StatelessWidget {
  final Widget child;
  final String text;
  const CursorHoverRegion({super.key, required this.child, this.text = AppStrings.open});

  @override
  Widget build(BuildContext context) {
    // Detect mobile to skip mouse effects
    final bool isMobileDevice = !kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
    final bool isWebMobile = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
    
    if (isMobileDevice || isWebMobile) return child;

    return MouseRegion(
      onEnter: (_) => Get.find<CursorController>().setHovering(true, text: text),
      onExit: (_) => Get.find<CursorController>().setHovering(false),
      child: child,
    );
  }
}
