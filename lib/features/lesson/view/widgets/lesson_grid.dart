import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/common/widgets/section_heading.dart';
import 'package:ashil_school/features/lesson/controller/lesson_controller.dart';
// import 'package:ashil_school/features/lesson/view/lesson_details_page.dart'; // افترض وجود هذه الصفحة
import 'package:ashil_school/features/lesson/view/widgets/lesson_card.dart';
import 'package:ashil_school/features/subject/controllers/subject_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// شبكة عرض الدروس (مشابهة لـ SubjectGrid)
class LessonGrid extends StatelessWidget {
  final LessonController lessonController;
  final SubjectDetailsController subjectDetailsController;
  final String unitName;

  const LessonGrid({
    super.key,
    required this.lessonController,
    required this.subjectDetailsController,
    required this.unitName,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (lessonController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (lessonController.lessons.isEmpty) {
        return Center(child: Text("لا توجد دروس في وحدة $unitName."));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KSectionHeading(title: "دروس الوحدة: $unitName"),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: lessonController.lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessonController.lessons[index];
                return LessonCard(
                  lesson: lesson,
                  onTap: () {
                    // [FIX] 2. التوجه لصفحة تفاصيل الدرس
                  //  Get.to(() => LessonDetailsPage(lesson: lesson));
                  },
                  onEdit: () {
                    // استدعاء دالة التعديل من متحكم صفحة المادة
                    subjectDetailsController.showAddEditLessonDialog(lesson);
                  },
                  onDelete: () => showConfirmationDialog(
                    onCancel: () => Get.back(),
                    title: "حذف الدرس",
                    message: "هل أنت متأكد من حذف درس ${lesson.title}؟",
                    onConfirm: () =>
                        lessonController.deleteLesson(lesson.id),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}