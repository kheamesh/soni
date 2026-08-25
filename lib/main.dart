import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'core/app_theme.dart';
import 'core/app_colors.dart';
import 'core/app_strings.dart';
import 'utils/responsive.dart';
import 'widgets/particle_background.dart';
import 'widgets/custom_cursor.dart';
import 'sections/hero_experience.dart';
import 'sections/digital_gallery.dart';
import 'sections/engine_room.dart';
import 'sections/thinking_space.dart';
import 'sections/the_lab.dart';
import 'sections/transmission_hub.dart';
import 'sections/footer_experience.dart';
import 'controllers/app_controller.dart';
import 'controllers/nav_controller.dart';

void main() {
  runApp(const SoniPortfolio());
}

class SoniPortfolio extends StatelessWidget {
  const SoniPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      // Custom Cursor at the very top
      home: const CustomCursor(child: MainLayout()),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  Widget _buildNavButton(String label, GlobalKey key, NavController navCtrl) {
    return GestureDetector(
      onTap: () => navCtrl.scrollToSection(key),
      child: CursorHoverRegion(
        text: "GOTO_$label",
        child:
            Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .shimmer(
                  duration: const Duration(seconds: 3),
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initializing global controllers
    final appController = Get.put(AppController());
    final navCtrl = Get.put(NavController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LAYER 1: Background Stars (Decorative)
          const ExcludeSemantics(child: ParticleBackground()),

          // LAYER 2: Main Content (Interactive)
          Obx(() {
            if (!appController.isBooted.value) return const SizedBox.shrink();

            return SingleChildScrollView(
              controller: navCtrl.scrollController,
              child: Column(
                children: [
                  HeroExperience(key: navCtrl.heroKey),
                  DigitalGallery(key: navCtrl.workKey),
                  EngineRoom(key: navCtrl.craftKey),
                  ThinkingSpace(key: navCtrl.thinkingKey),
                  TheLab(key: navCtrl.labKey),
                  TransmissionHub(key: navCtrl.contactKey),
                  const FooterExperience(),
                  const SizedBox(height: 100),
                ],
              ).animate().fadeIn(duration: const Duration(seconds: 1)),
            );
          }),

          // LAYER 3: HUD Elements (Decorative/Nav)
          Obx(() {
            if (!appController.isBooted.value) return const SizedBox.shrink();

            return ExcludeSemantics(
              child: Stack(
                children: [
                  // Top Right Nav
                  if (!Responsive.isMobile(context))
                    Positioned(
                          top: 40,
                          right: 40,
                          child: Row(
                            children: [
                              _buildNavButton(
                                AppStrings.navMe,
                                navCtrl.heroKey,
                                navCtrl,
                              ),
                              _buildNavButton(
                                AppStrings.navWork,
                                navCtrl.workKey,
                                navCtrl,
                              ),
                              _buildNavButton(
                                AppStrings.navCraft,
                                navCtrl.craftKey,
                                navCtrl,
                              ),
                              _buildNavButton(
                                AppStrings.navLab,
                                navCtrl.labKey,
                                navCtrl,
                              ),
                              _buildNavButton(
                                AppStrings.navContact,
                                navCtrl.contactKey,
                                navCtrl,
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: const Duration(seconds: 1))
                        .slideX(begin: 0.2, end: 0),

                  // Top Left Identity
                  Positioned(
                    top: Responsive.isMobile(context) ? 20 : 40,
                    left: Responsive.isMobile(context) ? 20 : 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                              AppStrings.userId,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Responsive.isMobile(context)
                                    ? 18
                                    : 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                              ),
                            )
                            .animate()
                            .fadeIn(delay: const Duration(milliseconds: 400))
                            .slideX(begin: -0.2, end: 0),
                        const SizedBox(height: 8),
                        Container(
                          width: Responsive.isMobile(context) ? 30 : 40,
                          height: 2,
                          color: AppColors.primary,
                        ).animate().scaleX(
                          delay: const Duration(milliseconds: 600),
                          begin: 0,
                          end: 1,
                          alignment: Alignment.centerLeft,
                        ),
                      ],
                    ),
                  ),

                  // Bottom Right Status
                  if (!Responsive.isMobile(context))
                    Positioned(
                      bottom: 40,
                      right: 40,
                      child:
                          const Text(
                                AppStrings.buildStatus,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  height: 1.5,
                                  letterSpacing: 2,
                                  fontFamily: 'monospace',
                                ),
                              )
                              .animate()
                              .fadeIn(delay: const Duration(milliseconds: 700))
                              .shake(
                                hz: 4,
                                duration: const Duration(milliseconds: 400),
                              )
                              .custom(
                                builder: (context, value, child) => Opacity(
                                  opacity: value < 0.5 ? 0.8 : 1.0,
                                  child: child,
                                ),
                              ),
                    ),
                ],
              ),
            );
          }),

          // LAYER 4: Loading Screen (Decorative)
          Obx(() {
            if (appController.isBooted.value) return const SizedBox.shrink();

            return Center(
              child: ExcludeSemantics(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                          AppStrings.initializing,
                          style: const TextStyle(
                            color: AppColors.primary,
                            letterSpacing: 4,
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat())
                        .shimmer(duration: const Duration(seconds: 1)),
                    const SizedBox(height: 20),
                    Container(
                      width: 300,
                      height: 1,
                      color: Colors.white12,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child:
                            Container(
                              width: 0,
                              height: 1,
                              color: AppColors.primary,
                            ).animate().custom(
                              duration: const Duration(milliseconds: 2500),
                              builder: (context, value, child) => Container(
                                width: 300 * value,
                                height: 1,
                                color: AppColors.primary,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
