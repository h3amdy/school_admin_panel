// lib/Utils/custom_dialogs.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/Utils/Styles.dart';
import 'package:ashil_school/AppResources.dart';

void showDeleteConfirmationDialog({
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) {
  Get.dialog(
    Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          title,
          style: normalStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          content,
          style: normalStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'إلغاء',
              style: normalStyle(color: secondaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // إغلاق المربع
              onConfirm(); // تنفيذ دالة الحذف
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'حذف',
              style: normalStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}