 import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:ashil_school/Utils/custom_dilog/cusom_dilog.dart';
import 'package:ashil_school/features/grade/controllers/grade_controller.dart';
import 'package:ashil_school/features/grade/models/grade.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAddEditGradeDialog(BuildContext context,GradeController controller, {GradeModel? grade}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: grade?.name ?? "");
    
    // Key Change: Set initial value for level dynamically
    final int initialLevel = grade?.order ?? (controller.grades.isEmpty ? 1 : controller.grades.last.order + 1);
    final levelController = TextEditingController(
      text: initialLevel.toString(),
    );
    final descriptionController =
        TextEditingController(text: grade?.description ?? "");

    Get.dialog(
      CustomDialog(
        title: grade == null ? "إضافة صف جديد" : "تعديل الصف",
        body: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: KSizes.spaceBewItems),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "اسم الصف"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم الصف';
                  }
                  return null;
                },
              ),
              const SizedBox(height: KSizes.spaceBewItems),
              TextFormField(
                controller: levelController,
                decoration: const InputDecoration(labelText: "المستوى"),
                keyboardType: TextInputType.number,
                // Key Change: Add validator to check for duplicates
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'الرجاء إدخال رقم صحيح للمستوى';
                  }
                  final int newLevel = int.parse(value);
                  final bool isDuplicate = controller.grades.any(
                    (g) => g.order == newLevel && g.id != grade?.id,
                  );
                  if (isDuplicate) {
                    return 'هذا الترتيب موجود بالفعل. الرجاء اختيار ترتيب آخر.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: KSizes.spaceBewItems),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "الوصف (اختياري)"),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: KSizes.spaceBewItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    child: const Text("إلغاء"),
                    onPressed: () => Get.back(),
                  ),
                  ElevatedButton(
                    child: Text(grade == null ? "إضافة" : "حفظ"),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final name = nameController.text.trim();
                        final level = int.parse(levelController.text.trim());
                        final description =
                            descriptionController.text.trim().isNotEmpty
                                ? descriptionController.text.trim()
                                : null;

                        if (grade == null) {
                          controller.addGrade(
                              name: name,
                              order: level,
                              description: description);
                        } else {
                          controller.updateGrade(grade.id,
                              name: name,
                              order: level,
                              description: description);
                        }
                        Get.back();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
