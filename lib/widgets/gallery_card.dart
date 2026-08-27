import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../core/app_icons.dart';
import '../utils/responsive.dart';
import '../controllers/gallery_controller.dart';
import '../widgets/custom_cursor.dart';
import '../widgets/tech_painters.dart';

class GalleryCard extends StatelessWidget {
  final String id;
  final int index;
  final String title;
  final String description;
  final String problem;
  final String engineeringBuild;
  final String result;
  final String? link;
  final String? imagePath;

  const GalleryCard({
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

    final cardWidth = isMobile ? Get.width * 0.65 : Get.width * 0.17;
    final cardHeight = isMobile ? Get.height * 0.45 : Get.height * 0.55;
    final mockupWidth = cardWidth * 0.75;
    final mockupHeight = isMobile ? Get.height * 0.32 : Get.height * 0.34;

    return GestureDetector(
      onTap: () => _showStory(context),
      child: CursorHoverRegion(
        text: AppStrings.inspect,
        child: MouseRegion(
          onEnter: (_) => controller.setHovered(id, true),
          onExit: (_) => controller.setHovered(id, false),
          onHover: (e) =>
              controller.updateTilt(id, e.localPosition, cardWidth, cardHeight),
          child: Obx(() {
            final isHovered = controller.isHovered(id).value;
            final tilt = controller.getTilt(id).value;

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(-tilt.dy * 0.1)
                ..rotateY(tilt.dx * 0.1),
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutQuint,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: cardWidth,
                child: Stack(
                  children: [
                    // Accretive Layer 1: Tech Corners
                    if (isHovered)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: TechCornerPainter(
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                        ).animate().fadeIn(),
                      ),

                    _buildCardContent(
                      isHovered,
                      isMobile,
                      cardWidth,
                      mockupWidth,
                      mockupHeight,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCardContent(
    bool isHovered,
    bool isMobile,
    double cardWidth,
    double mockupWidth,
    double mockupHeight,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      decoration: BoxDecoration(
        color: isHovered
            ? AppColors.textPrimary.withValues(alpha: 0.03)
            : AppColors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHovered
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.textPrimary.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Accretive Layer 2: Status Indicator
          if (isHovered || isMobile)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ID: PRJ_${index.toString().padLeft(3, '0')}",
                    style: TextStyle(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      fontSize: 8,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(width: 4, height: 4, color: AppColors.primary)
                      .animate(onPlay: (c) => c.repeat())
                      .scale(duration: GetNumUtils(1).seconds)
                      .fadeOut(),
                  const SizedBox(width: 10),
                  Text(
                    "STATUS: ${isHovered ? 'ACCESSING' : 'ENCRYPTED'}",
                    style: TextStyle(
                      color: isHovered
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontSize: 8,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),

          // THE MOCKUP
          Stack(
            alignment: Alignment.center,
            children: [
              // Accretive Layer 3: Background Glow
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                width: isHovered ? mockupWidth * 1.3 : 0,
                height: isHovered ? mockupHeight * 0.9 : 0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
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
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isHovered
                            ? AppColors.primary
                            : AppColors.textPrimary.withValues(alpha: 0.1),
                        width: 1.5,
                      ),
                      boxShadow: [
                        if (isHovered)
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 40,
                            spreadRadius: -10,
                          ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (imagePath != null)
                            Image.asset(imagePath!, fit: BoxFit.cover)
                          else
                            Center(
                              child: Icon(
                                AppIcons.smartphone,
                                color: AppColors.textPrimary.withValues(
                                  alpha: 0.1,
                                ),
                                size: 40,
                              ),
                            ),

                          // Accretive Layer 4: Scanning Sweep
                          if (isHovered)
                            Positioned.fill(
                              child:
                                  Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              AppColors.primary.withValues(
                                                alpha: 0.2,
                                              ),
                                              AppColors.transparent,
                                              AppColors.primary.withValues(
                                                alpha: 0.2,
                                              ),
                                            ],
                                            stops: const [0.0, 0.5, 1.0],
                                          ),
                                        ),
                                      )
                                      .animate(onPlay: (c) => c.repeat())
                                      .moveY(
                                        begin: -mockupHeight,
                                        end: mockupHeight,
                                        duration: GetNumUtils(2).seconds,
                                      ),
                            ),

                          // Accretive Layer 5: Glass Glare Effect
                          if (isHovered)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.white.withValues(alpha: 0.1),
                                      AppColors.transparent,
                                      AppColors.black.withValues(alpha: 0.05),
                                    ],
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(duration: 300.ms),

                          // Accretive Layer 6: Dynamic Data Fragments
                          if (isHovered)
                            ...List.generate(3, (i) {
                              return Positioned(
                                top: 20.0 + (i * 40),
                                right: 10,
                                child:
                                    Text(
                                          "0x${(i + index).toRadixString(16).padLeft(2, '0')}",
                                          style: TextStyle(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.4,
                                            ),
                                            fontSize: 6,
                                            fontFamily: 'monospace',
                                          ),
                                        )
                                        .animate(onPlay: (c) => c.repeat())
                                        .moveY(
                                          begin: 0,
                                          end: -20,
                                          duration: GetNumUtils(2).seconds,
                                        )
                                        .fadeOut(),
                              );
                            }),
                        ],
                      ),
                    ),
                  )
                  .animate(target: isHovered ? 1 : 0)
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.08, 1.08),
                  )
                  .rotate(begin: 0, end: 0.03),
            ],
          ),

          const Spacer(),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
              shadows: isHovered
                  ? [
                      Shadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
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
                  fontSize: isMobile ? 10 : 11,
                  height: 1.5,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
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
            color: AppColors.transparent,
            child:
                Container(
                      width: isMobile ? Get.width * 0.9 : 600,
                      height: Get.height * 0.8,
                      padding: EdgeInsets.all(isMobile ? 25 : 45),
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.98),
                        border: Border.all(color: AppColors.primary, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 50,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.05,
                              child: CustomPaint(
                                painter: GridPainter(spacing: 20),
                              ),
                            ),
                          ),

                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                          width: 8,
                                          height: 8,
                                          color: AppColors.primary,
                                        )
                                        .animate(onPlay: (c) => c.repeat())
                                        .scale()
                                        .fadeOut(),
                                    const SizedBox(width: 15),
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
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: Get.height * 0.04,
                                  ),
                                ),
                                _buildStorySection(
                                  AppStrings.problemLabel,
                                  problem,
                                  isMobile,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: Get.height * 0.03,
                                  ),
                                ),
                                _buildStorySection(
                                  AppStrings.buildLabel,
                                  engineeringBuild,
                                  isMobile,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: Get.height * 0.03,
                                  ),
                                ),
                                _buildStorySection(
                                  AppStrings.resultLabel,
                                  result,
                                  isMobile,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: Get.height * 0.05,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (link != null)
                                      TextButton.icon(
                                        onPressed: () async {
                                          final uri = Uri.parse(link!);
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          }
                                        },
                                        icon: const Icon(
                                          AppIcons.link,
                                          size: 18,
                                        ),
                                        label: const Text(
                                          AppStrings.viewSource,
                                          style: TextStyle(
                                            fontFamily: 'monospace',
                                            fontWeight: FontWeight.bold,
                                          ),
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
                        ],
                      ),
                    )
                    .animate()
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      curve: Curves.easeOutBack,
                    )
                    .fadeIn(),
          ),
        );
      },
    );
  }

  Widget _buildStorySection(String label, String content, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 10, height: 2, color: AppColors.primary),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: AppColors.primary.withValues(alpha: 0.8),
                fontSize: isMobile ? 10 : 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(bottom: Get.height * 0.01)),
        Text(
          content,
          style: TextStyle(
            color: AppColors.textPrimary.withValues(alpha: 0.9),
            fontSize: isMobile ? 12 : 15,
            height: 1.7,
            letterSpacing: 0.5,
          ),
        ).animate().fadeIn(delay: 200.ms).moveX(begin: 10, end: 0),
      ],
    );
  }
}
