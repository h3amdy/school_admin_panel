import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/common/widgets/section_heading.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart'; // [MODIFIED]
import 'package:ashil_school/features/lesson/view/lesson_details_page.dart';
// import 'package:ashil_school/features/lesson/view/lesson_details_page.dart';
import 'package:ashil_school/features/lesson/view/widgets/lesson_card.dart';
import 'package:ashil_school/features/subject/controllers/subject_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// شبكة عرض الدروس (مشابهة لـ SubjectGrid)
class LessonGrid extends StatelessWidget {
  // [MODIFIED] تم تغيير المدخلات
  final List<LessonModel> lessons;
  final SubjectDetailsController subjectDetailsController;

  const LessonGrid({
    super.key,
    required this.lessons,
    required this.subjectDetailsController,
  });

  @override
  Widget build(BuildContext context) {
    // [DELETED] تم إزالة Obx وحالات التحميل والفراغ (تمت معالجتها في الواجهة)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // يمكنك إزالة هذا العنوان إذا كان البحث يجعله غير دقيق
        KSectionHeading(title: "الدروس (${lessons.length})"),
        Expanded(
          child: GridView.builder(
            //  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: lessons.length, // [MODIFIED]
            itemBuilder: (context, index) {
              final lesson = lessons[index]; // [MODIFIED]
              return LessonCard(
                lesson: lesson,
                onTap: () {
                  Get.to(() => LessonDetailsPage(lesson: lesson));
                },
                onEdit: () {
                  // [MODIFIED] استدعاء الدالة من المتحكم الرئيسي
                  subjectDetailsController.showAddEditLessonDialog(context,
                      lesson: lesson);
                },
                onDelete: () => showConfirmationDialog(
                    onCancel: () => Get.back(),
                    title: "حذف الدرس",
                    message: "هل أنت متأكد من حذف درس ${lesson.title}؟",
                    // [MODIFIED] استدعاء الدالة من المتحكم الرئيسي
                    onConfirm: () {
                      subjectDetailsController.deleteLesson(lesson);
                      Get.back();
                    }),
              );
            },
          ),
        ),
      ],
    );
  }
}
