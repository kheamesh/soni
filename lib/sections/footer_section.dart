import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.whiteTransparent.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.footerCredit,
            style: TextStyle(
              color: AppColors.textPrimary.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.footerRights,
            style: TextStyle(
              color: AppColors.textPrimary.withValues(alpha: 0.2),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  AppStrings.privacyPolicy,
                  style: TextStyle(
                    color: AppColors.textPrimary.withValues(alpha: 0.2),
                  ),
                ),
              ),
              Text(
                "|",
                style: TextStyle(
                  color: AppColors.whiteTransparent.withValues(alpha: 0.1),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  AppStrings.termsOfService,
                  style: TextStyle(
                    color: AppColors.textPrimary.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
