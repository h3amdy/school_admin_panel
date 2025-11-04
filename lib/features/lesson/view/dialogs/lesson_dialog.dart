import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:ashil_school/Utils/custom_dilog/cusom_dilog.dart';
import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/features/lesson/controller/lesson_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/Utils/Styles.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';

class LessonDialog extends StatefulWidget {
  final LessonController lessonController;
  final LessonModel? lessonToEdit;
  final String? unitName;
  const LessonDialog(
      {super.key,
      required this.lessonController,
      this.lessonToEdit,
      this.unitName});

  @override
  State<LessonDialog> createState() => _NewLessonDialogState();
}

class _NewLessonDialogState extends State<LessonDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // ✅ هنا نقوم باستدعاء الدالة المناسبة لتهيئة المتحكمات في المتحكم الرئيسي
    if (widget.lessonToEdit != null) {
      widget.lessonController.prepareForEdit(widget.lessonToEdit!);
    } else {
      widget.lessonController.prepareForAdd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.lessonToEdit != null;
    final dialogTitle =
        isEditing ? "✏️ تعديل الدرس" : "إضافة درس للوحدة ${widget.unitName}";
    final buttonText = isEditing ? "حفظ التعديلات" : "إضافة";
    final lessonController = widget.lessonController;

    return CustomDialog(
      title: dialogTitle,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6),
                    // ✅ استخدام TextFormField مع validator
                    TextFormField(
                      controller: lessonController.nameController,
                      decoration:
                          const InputDecoration(labelText: "أدخل اسم الدرس"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال اسم الدرس';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: lessonController.contentController,
                      decoration:
                          const InputDecoration(labelText: "أدخل شرح الدرس"),
                      minLines: 6,
                      maxLines: 100,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال شرح الدرس';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: lessonController.orderController,
                      decoration:
                          const InputDecoration(labelText: "أدخل ترتيب الدرس"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال ترتيب الدرس';
                        }
                        if (int.tryParse(value) == null) {
                          return 'يرجى إدخال رقم صحيح للترتيب';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: KColors.warning)),
                  child: const Text("إلغاء"),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: 12),
                Obx(() {
                  final isLoading = lessonController.isLoading.value;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              if (isEditing) {
                                lessonController
                                    .updateLesson(widget.lessonToEdit!.id);
                              } else {
                                lessonController.addLesson();
                              }
                              Get.back();
                            } else {
                              KLoaders.error(
                                  title: "خطأ",
                                  message: "الرجاء مراجعة البيانات المدخلة");
                            }
                          },
                    child: isLoading
                        ? const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : Text(
                            buttonText,
                            textAlign: TextAlign.center,
                            style: normalStyle(color: Colors.white),
                          ),
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
