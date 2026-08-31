import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soni/core/app_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../utils/responsive.dart';
import '../controllers/footer_controller.dart';
import '../widgets/custom_cursor.dart';

class FooterExperience extends StatelessWidget {
  const FooterExperience({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FooterController());
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : 120,
        horizontal: isMobile ? 20 : 100,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.whiteTransparent.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // 1. Cinematic Closing Text
          Text(
                AppStrings.footerTitle,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: isMobile ? 20 : 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: isMobile ? 4 : 8,
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .shimmer(
                duration: const Duration(seconds: 3),
                color: AppColors.primary,
              ),

          const SizedBox(height: 20),

          Text(
            AppStrings.footerSubTitle,
            style: TextStyle(
              color: AppColors.primary.withValues(alpha: 0.8),
              fontSize: isMobile ? 12 : 16,
              letterSpacing: 4,
              fontFamily: 'monospace',
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 500)),

          const SizedBox(height: 80),

          // 2. The Unique Attraction: System Terminal Simulation
          _buildTerminal(isMobile, controller),

          const SizedBox(height: 80),

          // 3. Social Uplinks
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialUplink(
                AppIcons.github,
                AppStrings.githubLabel,
                AppStrings.githubUrl,
              ),
              const SizedBox(width: 30),
              _buildSocialUplink(
                AppIcons.linkedin,
                AppStrings.linkedinLabel,
                AppStrings.linkedinUrl,
              ),
              const SizedBox(width: 30),
              _buildSocialUplink(
                AppIcons.envelope,
                AppStrings.emailLabel,
                AppStrings.emailUrl,
              ),
            ],
          ),

          const SizedBox(height: 100),

          // 4. Handcrafted Signature & Copyright
          Column(
            children: [
              Text(
                AppStrings.ksSignature,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ).animate().fadeIn().scale().shimmer(color: AppColors.accent),
              const SizedBox(height: 20),
              Text(
                AppStrings.footerCopyright,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.5),
                  fontSize: isMobile ? 10 : 12,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTerminal(bool isMobile, FooterController controller) {
    return Container(
      width: isMobile ? double.infinity : 600,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.black,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.terminalRed,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.terminalAmber,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.terminalGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                AppStrings.systemLogs,
                style: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          Divider(
            color: AppColors.whiteTransparent.withValues(alpha: 0.1),
            height: 30,
          ),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.logs
                  .map(
                    (log) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        log,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ).animate().fadeIn().slideX(begin: -0.1, end: 0),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialUplink(dynamic icon, String label, String url) {
    return CursorHoverRegion(
      text: AppStrings.uplink,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        },
        child: Column(
          children: [
            if (icon is IconData)
              Icon(icon, color: AppColors.white, size: 24)
            else
              FaIcon(icon, color: AppColors.white, size: 24),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary.withValues(alpha: 0.6),
                fontSize: 10,
                letterSpacing: 2,
              ),
            ),
          ],
        ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
              begin: 0,
              end: -5,
              duration: const Duration(seconds: 2),
            ),
      ),
    );
  }
}
