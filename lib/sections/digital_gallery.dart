import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../widgets/custom_cursor.dart';
import '../controllers/gallery_controller.dart';

class DigitalGallery extends StatelessWidget {
  const DigitalGallery({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GalleryController());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Column(
        children: [
          Text(
            AppStrings.galleryTitle,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.w300),
          ).animate().fadeIn().moveY(begin: 20, end: 0),
          const SizedBox(height: 80),
          SizedBox(
            height: 500,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 50),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ProjectOrb(
                  id: "project_$index",
                  title: "${AppStrings.projectAlphaTitle} $index",
                  description: AppStrings.projectAlphaDesc,
                  problem: AppStrings.projectAlphaProblem,
                  engineeringBuild: AppStrings.projectAlphaBuild,
                  result: AppStrings.projectAlphaResult,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectOrb extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String problem;
  final String engineeringBuild;
  final String result;
  
  const ProjectOrb({
    super.key, 
    required this.id,
    required this.title, 
    required this.description,
    required this.problem,
    required this.engineeringBuild,
    required this.result,
  });

  void _showStory(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Story",
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.95),
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 40),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${AppStrings.storyHeader} $title", 
                    style: TextStyle(color: AppColors.primary, fontSize: 18, letterSpacing: 4, fontFamily: 'monospace')),
                  const SizedBox(height: 30),
                  _buildStorySection(AppStrings.problemLabel, problem),
                  const SizedBox(height: 20),
                  _buildStorySection(AppStrings.buildLabel, engineeringBuild),
                  const SizedBox(height: 20),
                  _buildStorySection(AppStrings.resultLabel, result),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppStrings.closeArchive, style: TextStyle(color: AppColors.accent, fontFamily: 'monospace')),
                    ),
                  ),
                ],
              ),
            ).animate().scale(begin: const Offset(0.9, 0.9)).fadeIn(),
          ),
        );
      },
    );
  }

  Widget _buildStorySection(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GalleryController>();

    return GestureDetector(
      onTap: () => _showStory(context),
      child: CursorHoverRegion(
        text: AppStrings.inspect,
        child: MouseRegion(
          onEnter: (_) => controller.setHovered(id, true),
          onExit: (_) => controller.setHovered(id, false),
          child: Obx(() {
            final isHovered = controller.isHovered(id).value;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              width: 300,
              decoration: BoxDecoration(
                color: isHovered ? AppColors.primary.withValues(alpha: 0.05) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isHovered ? AppColors.primary : Colors.white10,
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white24),
                            boxShadow: isHovered ? [
                              BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 30)
                            ] : [],
                          ),
                          child: const Icon(Icons.smartphone, color: Colors.white24, size: 50),
                        ).animate(target: isHovered ? 1 : 0)
                         .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1))
                         .rotate(begin: 0, end: 0.05),
                        const SizedBox(height: 30),
                        Text(
                          title,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        AnimatedOpacity(
                          opacity: isHovered ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
