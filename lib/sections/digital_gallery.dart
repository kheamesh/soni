import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:soni/core/app_icons.dart';
import 'package:soni/core/app_image.dart';
import 'package:soni/core/app_url.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../widgets/custom_cursor.dart';
import '../utils/responsive.dart';
import '../controllers/gallery_controller.dart';

class DigitalGallery extends StatefulWidget {
  const DigitalGallery({super.key});

  @override
  State<DigitalGallery> createState() => _DigitalGalleryState();
}

class _DigitalGalleryState extends State<DigitalGallery> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(GalleryController());
    final isMobile = Responsive.isMobile(context);

    // Calculate dynamic horizontal padding for centering
    final double itemWidth = Get.width * 0.17 + 4; // Card width + margins
    final double totalContentWidth = 6 * itemWidth;
    double horizontalPadding = (Get.width - totalContentWidth) / 2;
    if (horizontalPadding < 20) horizontalPadding = 20;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? Get.height * 0.08 : Get.height * 0.12,
      ),
      child: Column(
        children: [
          // Background Aesthetic Header
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                AppStrings.archive,
                style: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.03),
                  fontSize: isMobile ? Get.width * 0.2 : Get.width * 0.15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 20,
                ),
              ).animate().fadeIn(duration: const Duration(seconds: 1)),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.galleryTitle,
                    style: TextStyle(
                      color: AppColors.textPrimary.withValues(alpha: 0.9),
                      fontSize: isMobile ? 18 : 24,
                      letterSpacing: isMobile ? 5 : 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ).animate().fadeIn().moveY(begin: 20, end: 0),
                  Padding(padding: EdgeInsets.only(bottom: Get.height * 0.01)),
                  Container(
                    width: 40,
                    height: 2,
                    color: AppColors.primary,
                  ).animate().scaleX(delay: const Duration(milliseconds: 400)),
                ],
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(
              bottom: isMobile ? Get.height * 0.06 : Get.height * 0.1,
            ),
          ),

          // Center-aligned scrolling list
          SizedBox(
            height: isMobile ? Get.height * 0.55 : Get.height * 0.7,
            width: double.infinity,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : horizontalPadding,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final projectData = _getProjectData(index);

                if (projectData.isEmpty) {
                  return SizedBox(
                    width: isMobile ? Get.width * 0.65 : Get.width * 0.17,
                  );
                }

                return ProjectOrb(
                  id: "project_$index",
                  index: index,
                  title: projectData['title'],
                  description: projectData['desc'],
                  problem: projectData['problem'],
                  engineeringBuild: projectData['build'],
                  result: projectData['result'],
                  link: projectData['link'],
                  imagePath: projectData['image'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getProjectData(int index) {
    switch (index) {
      case 0:
        return {
          'title': AppStrings.projectAlphaTitle,
          'desc': AppStrings.projectAlphaDesc,
          'problem': AppStrings.projectAlphaProblem,
          'build': AppStrings.projectAlphaBuild,
          'result': AppStrings.projectAlphaResult,
          'link': AppUrl.projectAlphaLink,
          'image': AppImage.kohiraImage,
        };
      case 1:
        return {
          'title': AppStrings.projectBetaTitle,
          'desc': AppStrings.projectBetaDesc,
          'problem': AppStrings.projectBetaProblem,
          'build': AppStrings.projectBetaBuild,
          'result': AppStrings.projectBetaResult,
          'link': AppUrl.projectBetaLink,
          'image': AppImage.classicImage,
        };
      case 2:
        return {
          'title': AppStrings.projectGammaTitle,
          'desc': AppStrings.projectGammaDesc,
          'problem': AppStrings.projectGammaProblem,
          'build': AppStrings.projectGammaBuild,
          'result': AppStrings.projectGammaResult,
          'link': AppUrl.projectGammaLink,
          'image': AppImage.hirexpertImage,
        };
      case 3:
        return {
          'title': AppStrings.projectDeltaTitle,
          'desc': AppStrings.projectDeltaDesc,
          'problem': AppStrings.projectDeltaProblem,
          'build': AppStrings.projectDeltaBuild,
          'result': AppStrings.projectDeltaResult,
          'link': AppUrl.projectDeltaLink,
          'image': AppImage.traadetImage,
        };
      case 4:
        return {
          'title': AppStrings.projectMetalTitle,
          'desc': AppStrings.projectMetalDesc,
          'problem': AppStrings.projectMetalProblem,
          'build': AppStrings.projectMetalBuild,
          'result': AppStrings.projectMetalResult,
          'link': AppUrl.projectMetalLink,
          'image': AppImage.rukminiImage,
        };
      default:
        return {};
    }
  }
}

class ProjectOrb extends StatelessWidget {
  final String id;
  final int index;
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
    required this.index,
    required this.title,
    required this.description,
    required this.problem,
    required this.engineeringBuild,
    required this.result,
    this.link,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GalleryController>();
    final isMobile = Responsive.isMobile(context);

    // Small-Medium Proportional Sizing
    final cardWidth = isMobile ? Get.width * 0.65 : Get.width * 0.17;
    final mockupWidth = cardWidth * 0.75;
    final mockupHeight = isMobile ? Get.height * 0.32 : Get.height * 0.34;

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
              curve: Curves.easeOutQuint,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: cardWidth,
              decoration: BoxDecoration(
                color: isHovered
                    ? AppColors.textPrimary.withValues(alpha: 0.03)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isHovered ? AppColors.primary.withValues(alpha: 0.3) : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // THE MOCKUP
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        width: isHovered ? mockupWidth * 1.2 : 0,
                        height: isHovered ? mockupHeight * 0.8 : 0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              blurRadius: 100,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: mockupWidth,
                        height: mockupHeight,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isHovered ? AppColors.primary : AppColors.textPrimary.withValues(alpha: 0.1), 
                            width: 1.5
                          ),
                          boxShadow: [
                            if (isHovered)
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                blurRadius: 30,
                              ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          child: imagePath != null
                              ? Image.asset(
                                  imagePath!,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Icon(
                                    AppIcons.smartphone,
                                    color: AppColors.textPrimary.withValues(alpha: 0.1),
                                    size: 40,
                                  ),
                                ),
                        ),
                      )
                      .animate(target: isHovered ? 1 : 0)
                      .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05))
                      .rotate(begin: 0, end: 0.02),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: isMobile ? 16 : 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  
                  Padding(padding: EdgeInsets.only(bottom: Get.height * 0.015)),
                  
                  AnimatedOpacity(
                    opacity: isHovered || isMobile ? 0.7 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: cardWidth * 0.1),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: isMobile ? 10 : 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showStory(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppStrings.storyHeader,
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: isMobile ? Get.width * 0.9 : 600,
              height: Get.height * 0.8,
              padding: EdgeInsets.all(isMobile ? 25 : 45),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.98),
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 50,
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: Get.height * 0.04)),
                    _buildStorySection(AppStrings.problemLabel, problem, isMobile),
                    Padding(padding: EdgeInsets.only(bottom: Get.height * 0.03)),
                    _buildStorySection(AppStrings.buildLabel, engineeringBuild, isMobile),
                    Padding(padding: EdgeInsets.only(bottom: Get.height * 0.03)),
                    _buildStorySection(AppStrings.resultLabel, result, isMobile),
                    Padding(padding: EdgeInsets.only(bottom: Get.height * 0.05)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (link != null)
                          TextButton.icon(
                            onPressed: () async {
                              final uri = Uri.parse(link!);
                              if (await canLaunchUrl(uri)) await launchUrl(uri);
                            },
                            icon: const Icon(AppIcons.link, size: 18),
                            label: const Text(
                              AppStrings.viewSource,
                              style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
                            ),
                            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                          ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            AppStrings.closeArchive,
                            style: TextStyle(color: AppColors.accent, fontFamily: 'monospace'),
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
        Padding(padding: EdgeInsets.only(bottom: Get.height * 0.01)),
        Text(
          content,
          style: TextStyle(
            color: AppColors.textPrimary.withValues(alpha: 0.8),
            fontSize: isMobile ? 12 : 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
