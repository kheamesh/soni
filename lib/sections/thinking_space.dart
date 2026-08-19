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
      padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 100),
      child: Column(
        children: [
          Text(
            AppStrings.mentalSandbox,
            style: TextStyle(
              color: Colors.white, 
              fontSize: isMobile ? 12 : 14, 
              letterSpacing: isMobile ? 5 : 10, 
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: isMobile ? 60 : 100),
          QuestionBlock(
            id: "why",
            question: AppStrings.whyQuestion, 
            initialAnswer: AppStrings.whyInitial,
            glitchAnswer: AppStrings.whyGlitch,
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 60 : 100),
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
                fontSize: isMobile ? 40 : 80,
                fontWeight: FontWeight.w900,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ).animate(target: revealed ? 1 : 0).tint(color: AppColors.primary);
          }),
          Obx(() {
            final revealed = controller.isRevealed(id).value;
            final glitched = controller.isGlitched(id).value;
            
            if (!revealed) return const SizedBox.shrink();
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: isMobile ? 80 : 60,
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
                      color: glitched ? AppColors.accent : Colors.white, 
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
