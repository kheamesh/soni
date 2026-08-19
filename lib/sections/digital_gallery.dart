import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:soni/core/app_image.dart';
import 'package:soni/core/app_url.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../widgets/custom_cursor.dart';
import '../utils/responsive.dart';
import '../controllers/gallery_controller.dart';

class DigitalGallery extends StatelessWidget {
  const DigitalGallery({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GalleryController());
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 100),
      child: Column(
        children: [
          Text(
            AppStrings.galleryTitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: isMobile ? 18 : 24,
              letterSpacing: isMobile ? 5 : 10,
              fontWeight: FontWeight.w300,
            ),
          ).animate().fadeIn().moveY(begin: 20, end: 0),
          SizedBox(height: isMobile ? 40 : 80),
          SizedBox(
            height: isMobile ? 400 : 500,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 50),
              itemCount: 5,
              itemBuilder: (context, index) {
                // Project 1: Kohira
                if (index == 0) {
                  return ProjectOrb(
                    id: "project_0",
                    title: AppStrings.projectAlphaTitle,
                    description: AppStrings.projectAlphaDesc,
                    problem: AppStrings.projectAlphaProblem,
                    engineeringBuild: AppStrings.projectAlphaBuild,
                    result: AppStrings.projectAlphaResult,
                    link: AppUrl.projectAlphaLink,
                    imagePath: AppImage.kohiraImage,
                  );
                }

                // Project 2: Classic
                if (index == 1) {
                  return ProjectOrb(
                    id: "project_1",
                    title: AppStrings.projectBetaTitle,
                    description: AppStrings.projectBetaDesc,
                    problem: AppStrings.projectBetaProblem,
                    engineeringBuild: AppStrings.projectBetaBuild,
                    result: AppStrings.projectBetaResult,
                    link: AppUrl.projectBetaLink,
                    imagePath: AppImage.classicImage,
                  );
                }

                // Project 3: Hirexpert
                if (index == 2) {
                  return ProjectOrb(
                    id: "project_2",
                    title: AppStrings.projectGammaTitle,
                    description: AppStrings.projectGammaDesc,
                    problem: AppStrings.projectGammaProblem,
                    engineeringBuild: AppStrings.projectGammaBuild,
                    result: AppStrings.projectGammaResult,
                    link: AppUrl.projectGammaLink,
                    imagePath: AppImage.hirexpertImage,
                  );
                }

                // Project 4: Tradeat
                if (index == 3) {
                  return ProjectOrb(
                    id: "project_3",
                    title: AppStrings.projectDeltaTitle,
                    description: AppStrings.projectDeltaDesc,
                    problem: AppStrings.projectDeltaProblem,
                    engineeringBuild: AppStrings.projectDeltaBuild,
                    result: AppStrings.projectDeltaResult,
                    link: AppUrl.projectDeltaLink,
                    imagePath: AppImage.traadetImage,
                  );
                }

                // Project 5: Rukmini
                if (index == 4) {
                  return ProjectOrb(
                    id: "project_4",
                    title: AppStrings.projectMetalTitle,
                    description: AppStrings.projectMetalDesc,
                    problem: AppStrings.projectMetalProblem,
                    engineeringBuild: AppStrings.projectMetalBuild,
                    result: AppStrings.projectMetalResult,
                    link: AppUrl.projectMetalLink,
                    imagePath: AppImage.rukminiImage,
                  );
                }

                return const SizedBox.shrink();
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
  final String? link;
  final String? imagePath;

  const ProjectOrb({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.problem,
    required this.engineeringBuild,
    required this.result,
    this.link,
    this.imagePath,
  });

  void _showStory(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Story",
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: isMobile ? MediaQuery.of(context).size.width * 0.9 : 600,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.all(isMobile ? 20 : 40),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.95),
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 40,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${AppStrings.storyHeader} $title",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: isMobile ? 14 : 18,
                        letterSpacing: 4,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildStorySection(
                      AppStrings.problemLabel,
                      problem,
                      isMobile,
                    ),
                    const SizedBox(height: 20),
                    _buildStorySection(
                      AppStrings.buildLabel,
                      engineeringBuild,
                      isMobile,
                    ),
                    const SizedBox(height: 20),
                    _buildStorySection(
                      AppStrings.resultLabel,
                      result,
                      isMobile,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (link != null)
                          TextButton.icon(
                            onPressed: () async {
                              final uri = Uri.parse(link!);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                            icon: const Icon(Icons.link, size: 16),
                            label: const Text(
                              AppStrings.viewSource,
                              style: TextStyle(fontFamily: 'monospace'),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                            ),
                          ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            AppStrings.closeArchive,
                            style: TextStyle(
                              color: AppColors.accent,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().scale(begin: const Offset(0.9, 0.9)).fadeIn(),
          ),
        );
      },
    );
  }

  Widget _buildStorySection(String label, String content, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: isMobile ? 10 : 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isMobile ? 12 : 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GalleryController>();
    final isMobile = Responsive.isMobile(context);

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
              margin: EdgeInsets.symmetric(horizontal: isMobile ? 15 : 40),
              width: isMobile ? 260 : 300,
              decoration: BoxDecoration(
                color: isHovered
                    ? AppColors.primary.withValues(alpha: 0.05)
                    : Colors.transparent,
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
                              width: isMobile ? 120 : 150,
                              height: isMobile ? 200 : 250,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white24),
                                boxShadow: isHovered
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 30,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: imagePath != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.asset(
                                        imagePath!,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : Icon(
                                      Icons.smartphone,
                                      color: Colors.white24,
                                      size: isMobile ? 40 : 50,
                                    ),
                            )
                            .animate(target: isHovered ? 1 : 0)
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.1, 1.1),
                            )
                            .rotate(begin: 0, end: 0.05),
                        const SizedBox(height: 30),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedOpacity(
                          opacity: isHovered || isMobile ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isMobile ? 10 : 12,
                              ),
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
