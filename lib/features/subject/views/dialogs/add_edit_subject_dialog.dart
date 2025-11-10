import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:ashil_school/Utils/custom_dilog/custom_dialog.dart';
import 'package:ashil_school/features/subject/controllers/subject_controller.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:ashil_school/features/semester/models/semester.dart';

void showAddEditSubjectDialog({
  required SubjectController controller,
  required Rx<SemesterModel?> selectedSemester,
  SubjectModel? subject,
  String? gradeName,
}) {
  final nameController = TextEditingController(text: subject?.name ?? "");
  final descriptionController =
      TextEditingController(text: subject?.description ?? "");
  final orderController =
      TextEditingController(text: subject?.order?.toString() ?? "");

  if (selectedSemester.value == null) {
    Get.snackbar("خطأ", "يجب تحديد فصل دراسي أولاً لإضافة مادة.");
    return;
  }

  Get.dialog(
    CustomDialog(
      title: subject == null
          ? "إضافة مادة للصف ($gradeName) الفصل (${selectedSemester.value?.name ?? ""})"
          : "تعديل المادة",
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "اسم المادة"),
          ),
          const SizedBox(height: KSizes.spaceBewItems),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: "الوصف (اختياري)"),
            maxLines: 3,
          ),
          const SizedBox(height: KSizes.spaceBewItems),
          TextField(
            controller: orderController,
            decoration: const InputDecoration(labelText: "الترتيب (اختياري)"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
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
                  final name = nameController.text.trim();
                  final description = descriptionController.text.trim();
                  final order = int.tryParse(orderController.text.trim());

                  if (name.isNotEmpty) {
                    if (subject == null) {
                      controller.addSubject(
                        name: name,
                        description: description.isNotEmpty ? description : null,
                        order: order,
                      );
                    } else {
                      controller.updateSubject(
                        subject.id,
                        name: name,
                        description: description.isNotEmpty ? description : null,
                        order: order,
                      );
                    }
                    Get.back();
                  } else {
                    Get.snackbar("خطأ", "الرجاء إدخال اسم المادة.");
                  }
                },
                child: Text(subject == null ? "إضافة" : "حفظ"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
