//  ✅  AppNotifier:  فئة  مساعدة  لإنشاء  أنواع  مختلفة  من  التنبيهات  بسهولة
import 'package:ashil_school/Utils/custom_widgets/custom_snac_bar.dart';
import 'package:flutter/material.dart';

class KLoaders {
  static String? _lastSnackBarId;
  static Future<void>? _lastSnackBarFuture;

  static Future<void> _showSnackBar({
    required String title,
    String? message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    int duration = 3,
    String? snackBarId,
  }) async {
    final id = snackBarId ?? "";
    final shouldWait = _lastSnackBarFuture != null &&
        (id.isEmpty ||
            _lastSnackBarId?.isEmpty == true ||
            id != _lastSnackBarId);

    if (shouldWait) {
      await _lastSnackBarFuture;
    }

    final future = CustomSnackBar.show(
      title: title,
      message: message,
      delay: Duration(seconds: duration),
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
    );

    _lastSnackBarId = id;
    _lastSnackBarFuture = future;

    future.whenComplete(() {
      if (_lastSnackBarFuture == future) {
        _lastSnackBarFuture = null;
        _lastSnackBarId = null;
      }
    });

    return future;
  }

  static Future<void> success({
    required String title,
    String? message,
    int duration = 3,
    String? snackBarId,
  }) async {
    await _showSnackBar(
      title: title,
      message: message,
      duration: duration,
      snackBarId: snackBarId,
      backgroundColor: Colors.green.shade600,
      textColor: Colors.white,
      icon: Icons.check_circle,
    );
  }

  static Future<void> warning({
    required String title,
    String? message,
    int duration = 3,
    String? snackBarId,
  }) async {
    await _showSnackBar(
      title: title,
      message: message,
      duration: duration,
      snackBarId: snackBarId,
      backgroundColor: Colors.orange.shade600,
      textColor: Colors.white,
      icon: Icons.warning_amber_rounded,
    );
  }

  static Future<void> info({
    required String title,
    String? message,
    int duration = 3,
    String? snackBarId,
  }) async {
    await _showSnackBar(
      title: title,
      message: message,
      duration: duration,
      snackBarId: snackBarId,
      backgroundColor: Colors.blue.shade600,
      textColor: Colors.white,
      icon: Icons.info_outline,
    );
  }

  static Future<void> error({
    String? title,
    String? message,
    int duration = 3,
    String? snackBarId,
  }) async {
    await _showSnackBar(
      title: title ?? "حدث  خطأ",
      message: message,
      duration: duration,
      snackBarId: snackBarId,
      backgroundColor: Colors.red.shade600,
      textColor: Colors.white,
      icon: Icons.error,
    );
  }

  static void showFeatureComingSoon() {
    KLoaders.info(title: "هذه  الميزة  ستكون  متوفرة  قريبًا!");
  }
}
