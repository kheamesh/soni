import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../utils/responsive.dart';
import '../controllers/thinking_controller.dart';

class ThinkingSpace extends StatelessWidget {
  const ThinkingSpace({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThinkingController());
    final isMobile = Responsive.isMobile(context);
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? Get.height * 0.06 : Get.height * 0.1),
      child: Column(
        children: [
          Text(
            AppStrings.mentalSandbox,
            style: TextStyle(
              color: AppColors.textPrimary, 
              fontSize: isMobile ? 12 : 14, 
              letterSpacing: isMobile ? 5 : 10, 
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: isMobile ? Get.height * 0.08 : Get.height * 0.12),
          QuestionBlock(
            id: "why",
            question: AppStrings.whyQuestion, 
            initialAnswer: AppStrings.whyInitial,
            glitchAnswer: AppStrings.whyGlitch,
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? Get.height * 0.08 : Get.height * 0.12),
          QuestionBlock(
            id: "whatif",
            question: AppStrings.whatIfQuestion, 
            initialAnswer: AppStrings.whatIfInitial,
            glitchAnswer: AppStrings.whatIfGlitch,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }
}

class QuestionBlock extends StatelessWidget {
  final String id;
  final String question;
  final String initialAnswer;
  final String glitchAnswer;
  final bool isMobile;
  
  const QuestionBlock({
    super.key, 
    required this.id,
    required this.question, 
    required this.initialAnswer,
    required this.glitchAnswer,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThinkingController>();
    
    return GestureDetector(
      onTap: () {
        if (!controller.isRevealed(id).value) {
          controller.toggleRevealed(id);
        } else {
          controller.toggleGlitched(id);
        }
      },
      child: Column(
        children: [
          Obx(() {
            final revealed = controller.isRevealed(id).value;
            return Text(
              question,
              style: TextStyle(
                fontSize: isMobile ? Get.width * 0.12 : Get.width * 0.06,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary.withValues(alpha: 0.05),
              ),
            ).animate(target: revealed ? 1 : 0).tint(color: AppColors.primary);
          }),
          Obx(() {
            final revealed = controller.isRevealed(id).value;
            final glitched = controller.isGlitched(id).value;
            
            if (!revealed) return const SizedBox.shrink();
            
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: SizedBox(
                height: isMobile ? Get.height * 0.1 : Get.height * 0.08,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return child.animate().shake(hz: 10, duration: const Duration(milliseconds: 200)).fadeIn();
                  },
                  child: Text(
                    glitched ? glitchAnswer : initialAnswer,
                    key: ValueKey(glitched),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: glitched ? AppColors.accent : AppColors.textPrimary, 
                      fontSize: isMobile ? 16 : 20, 
                      fontStyle: FontStyle.italic,
                      fontFamily: glitched ? 'monospace' : null,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
