import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soni/core/app_colors.dart';
import 'package:file_saver/file_saver.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../core/app_strings.dart';

class HeroExperienceController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  Future<void> viewCV() async {
    try {
      Get.dialog(
        Dialog(
          backgroundColor: AppColors.background,
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppColors.primary, width: 2),
          ),
          child: SizedBox(
            width: Get.width * 0.8,
            height: Get.height * 0.9,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppStrings.cvPreviewTitle,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.primary),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SfPdfViewer.asset(
                    AppStrings.resumeAsset,
                    canShowScrollHead: true,
                    canShowScrollStatus: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      Get.snackbar(AppStrings.errorLabel, "${AppStrings.cvOpenError}: $e");
    }
  }

  Future<void> downloadCV() async {
    try {
      final byteData = await rootBundle.load(AppStrings.resumeAsset);
      final Uint8List bytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );

      // Using file_saver to trigger a download
      await FileSaver.instance.saveFile(
        name: AppStrings.cvDownloadName,
        bytes: bytes,
        file: 'pdf',
        mimeType: MimeType.pdf,
      );

      Get.snackbar(
        AppStrings.successLabel,
        AppStrings.cvDownloadSuccess,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.7),
        colorText: AppColors.white,
      );
    } catch (e) {
      Get.snackbar(AppStrings.errorLabel, "${AppStrings.cvDownloadError}: $e");
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
