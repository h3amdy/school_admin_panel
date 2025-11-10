import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:ashil_school/Utils/constants/image_strings.dart';
import 'package:ashil_school/Utils/helpers/helper_functions.dart';
import 'package:ashil_school/Utils/helpers/loaders/animation_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A utility class for managing a full-screen loading dialog.
class KFullScreenLoader {
  /// Open a full-screen loading dialog with a given text and animation.
  /// This method doesn't return anything.
  ///
  /// Parameters:
  /// - text: The text to be displayed in the loading dialog.
  /// - animation: The Lottie animation to be shown.
  static void openLoadingDialog(
      {String text = '', String animation = KImages.procese}) {
    showDialog(
      context:
          Get.overlayContext!, // Use Get.overlayContext for overlay dialogs
      barrierDismissible:
          false, // The dialog can't be dismissed by tapping outside it
      builder: (_) => PopScope(
        canPop: false, // Disable popping with the back button
        child: Center(
          child: Container(
            color: KHelperFunctions.isDarkMode(Get.context!)
                ? KColors.dark
                : KColors.white,
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                // السماح بالتمرير عند الحاجة
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Adjust the spacing as needed
                    Center(
                        child: KAnimationLoaderWidget(
                            text: text, animation: animation)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void stopLoading() {
    if (Get.overlayContext != null &&
        Navigator.of(Get.overlayContext!).canPop()) {
      Navigator.of(Get.overlayContext!).pop();
    }
  }
}
