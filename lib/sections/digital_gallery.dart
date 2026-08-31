import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../core/app_image.dart';
import '../core/app_url.dart';
import '../utils/responsive.dart';
import '../controllers/gallery_controller.dart';
import '../widgets/gallery_card.dart';
import '../widgets/tech_painters.dart';
import '../widgets/accretive_data_feed.dart';

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
    final double cardWidth = isMobile ? Get.width * 0.5 : Get.width * 0.16;
    final double itemWidth = cardWidth + 30; // Card width + margins
    final double totalContentWidth = 5 * itemWidth;
    double horizontalPadding = (Get.width - totalContentWidth) / 1.5;
    if (horizontalPadding < 30) horizontalPadding = 30;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? Get.height * 0.08 : Get.height * 0.05,
      ),
      child: Stack(
        children: [
          // Subtle Tech Grid Background
          if (!isMobile)
            Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: CustomPaint(painter: GridPainter(spacing: 40)),
              ),
            ),

          Column(
            children: [
              // Background Aesthetic Header
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    AppStrings.archive,
                    style: TextStyle(
                      color: AppColors.textPrimary.withValues(alpha: 0.08),
                      fontSize: isMobile ? Get.width * 0.2 : Get.width * 0.15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 20,
                    ),
                  ).animate().fadeIn(duration: const Duration(seconds: 1)),

                  // Scanning Line for Header
                  if (!isMobile)
                    Positioned.fill(
                      child:
                          Center(
                                child: Container(
                                  width: Get.width * 0.5,
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.transparent,
                                        AppColors.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                        AppColors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .animate(onPlay: (c) => c.repeat())
                              .moveY(
                                begin: -50,
                                end: 50,
                                duration: const Duration(seconds: 4),
                                curve: Curves.easeInOut,
                              )
                              .fadeOut(),
                    ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              )
                              .animate(onPlay: (c) => c.repeat())
                              .scale(duration: const Duration(seconds: 1))
                              .fadeOut(),
                          const SizedBox(width: 10),
                          Text(
                            AppStrings.galleryTitle,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: isMobile ? 18 : 24,
                              letterSpacing: isMobile ? 5 : 10,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ).animate().fadeIn().moveY(begin: 20, end: 0),
                      Padding(
                        padding: EdgeInsets.only(bottom: Get.height * 0.01),
                      ),
                      Container(
                        width: 60,
                        height: 2,
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ).animate().scaleX(
                        delay: const Duration(milliseconds: 400),
                      ),
                    ],
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(
                  bottom: isMobile ? Get.height * 0.06 : Get.height * 0.01,
                ),
              ),

              // Center-aligned scrolling list
              SizedBox(
                height: isMobile ? Get.height * 0.55 : Get.height * 0.5,
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
                  itemCount: AppStrings.projects.length,
                  itemBuilder: (context, index) {
                    final project = AppStrings.projects[index];

                    return GalleryCard(
                      id: "project_$index",
                      index: index,
                      title: project.title,
                      description: project.desc,
                      problem: project.problem,
                      engineeringBuild: project.build,
                      result: project.result,
                      link: project.link,
                      imagePath: project.image,
                    );
                  },
                ),
              ),

              if (!isMobile)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: AccretiveDataFeed(),
                ).animate().fadeIn(delay: GetNumUtils(1).seconds),
            ],
          ),
        ],
      ),
    );
  }
}
