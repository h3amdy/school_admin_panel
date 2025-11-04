import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:ashil_school/Utils/custom_dilog/cusom_dilog.dart';
import 'package:ashil_school/features/semester/controllers/semester_controller.dart';
import 'package:ashil_school/features/semester/models/semester.dart';

void showAddEditSemesterDialog({
  required SemesterController controller,
  SemesterModel? semester,
  String? gradeName,
}) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: semester?.name ?? "");
  final descriptionController =
      TextEditingController(text: semester?.description ?? "");

  // Key Change: Set initial value for order dynamically
  final int initialOrder = semester?.order ??
      (controller.semesters.isEmpty ? 1 : controller.semesters.last.order + 1);
  final orderController =
      TextEditingController(text: initialOrder.toString());

  Get.dialog(
    CustomDialog(
      title: semester == null
          ? "إضافة فصل للصف ($gradeName)"
          : "تعديل الفصل",
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: KSizes.spaceBewItems),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "اسم الفصل"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال اسم الفصل';
                }
                return null;
              },
            ),
            const SizedBox(height: KSizes.spaceBewItems),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "التفاصيل (اختياري)"),
              maxLines: 3,
            ),
            const SizedBox(height: KSizes.spaceBewItems),
            TextFormField(
              controller: orderController,
              decoration: const InputDecoration(labelText: "ترتيب الفصل"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || int.tryParse(value) == null) {
                  return 'الرجاء إدخال رقم صحيح للترتيب';
                }
                final int newOrder = int.parse(value);
                final bool isDuplicate = controller.semesters.any(
                  (s) => s.order == newOrder && s.id != semester?.id,
                );
                if (isDuplicate) {
                  return 'هذا الترتيب موجود بالفعل. الرجاء اختيار ترتيب آخر.';
                }
                return null;
              },
            ),
            const SizedBox(height: KSizes.spaceBewItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text("إلغاء"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final name = nameController.text.trim();
                      final description = descriptionController.text.trim();
                      final order = int.tryParse(orderController.text.trim()) ?? 0;
                      
                      if (semester == null) {
                        controller.addSemester(
                          name: name,
                          order: order,
                          description: description.isNotEmpty ? description : null,
                        );
                      } else {
                        controller.updateSemester(
                          semester.id,
                          name: name,
                          order: order,
                          description: description.isNotEmpty ? description : null,
                        );
                      }
                      Get.back();
                    }
                  },
                  child: Text(semester == null ? "إضافة" : "حفظ"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
