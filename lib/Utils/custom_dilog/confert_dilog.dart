import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/Utils/custom_dilog/custom_dialog.dart';

/// يعرض مربع حوار للتأكيد مع خيارين "نعم" و "إلغاء".
/// تم تحسينه لاستخدام CustomDialog لتوحيد المظهر.
void showConfirmationDialog({
  required String message,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
  String? title,
  bool isDestructive = false,
}) {
  Get.dialog(
    CustomDialog(
      title: title ?? 'تأكيد',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: Get.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton( // ✅ تحسين: استخدام زر خارجي لـ "إلغاء"
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onCancel,
                  child: const Text('إلغاء'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDestructive ? Colors.red : null,
                    minimumSize: const Size(0, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onConfirm,
                  child: const Text('نعم'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// يعرض مربع حوار بخياري "تعديل" و "حذف".
/// تم تحسينه لاستخدام CustomDialog.
/// ✅ تم إضافة `itemName` ليكون اسم العنصر اختيارياً.
void showEditDeleteOptions({
  required VoidCallback onEdit,
  required VoidCallback onDelete,
  String? itemName, // ✅ هنا نستقبل اسم العنصر
}) {
  Get.dialog(
    CustomDialog(
      title: 'خيارات',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              onEdit();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('تعديل'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Get.back(); // إغلاق مربع الخيارات الحالي
              
              // ✅ بناء رسالة التأكيد بناءً على وجود اسم العنصر
              final String confirmationMessage = itemName != null
                  ? 'هل أنت متأكد من أنك تريد حذف ${itemName}؟ لا يمكن التراجع عن هذا الإجراء.'
                  : 'هل أنت متأكد من أنك تريد حذف هذا العنصر؟ لا يمكن التراجع عن هذا الإجراء.';

              showConfirmationDialog(
                title: 'حذف',
                message: confirmationMessage,
                isDestructive: true,
                onConfirm: () {
                  Get.back(); // إغلاق مربع التأكيد
                  onDelete(); // تنفيذ دالة الحذف الفعلية
                },
                onCancel: () {
                  Get.back(); // إغلاق مربع التأكيد
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    ),
  );
}