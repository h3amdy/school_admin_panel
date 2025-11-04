import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/common/widgets/section_heading.dart';
import 'package:ashil_school/features/lesson/view/lesson_content_widget.dart';
import 'package:ashil_school/features/lesson/view/lessons_list_widget.dart'; // استخدام LessonListWidget المعدل
import 'package:ashil_school/features/question/views/questions_page.dart';
import 'package:ashil_school/features/subject/controllers/subject_details_controller.dart';
import 'package:ashil_school/features/unit/view/units_list_widget.dart'; // استخدام UnitListWidget المعدل
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectDetailsPage extends StatelessWidget {
  final SubjectModel subject;

  const SubjectDetailsPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubjectDetailsController(subject));

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("📘 ${subject.name}"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        final selectedUnit = controller.selectedUnit.value;
        final selectedLesson = controller.selectedLesson.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 قائمة الوحدات
            KSectionHeading(title: "الوحدات"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              // استخدام UnitListWidget مع تمرير البيانات والدوال من المتحكم الرئيسي
              child: UnitListWidget(unitController: controller.unitController),
            ),

            const Divider(height: 1),

            // 🔹 دروس الوحدة المختارة
            if (selectedUnit != null) ...[
              KSectionHeading(title: "📖 دروس وحدة: ${selectedUnit.name}"),
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                // استخدام LessonListWidget مع تمرير البيانات والدوال من المتحكم الرئيسي
                child: LessonListWidget(
                  lessons: controller.lessons,
                  selectedLesson: selectedLesson,
                  onLessonSelected: controller.selectLesson,
                  isLoading: controller.isLoadingLessons.value,
                  onEdit:
                      controller.showAddEditLessonDialog, // تمرير دالة التعديل
                  onDelete: (lessonId) => showConfirmationDialog(
                    // دالة الحذف
                    onCancel: () => Get.back(),
                    title: "حذف الدرس",
                    message: "هل أنت متأكد من حذف هذا الدرس؟",
                    onConfirm: () {
                      controller.deleteLesson(lessonId);
                      Get.back();
                    },
                  ),
                ),
              ),
            ] else
              Expanded(
                child: Center(
                  child: Text(
                    "اختر وحدة لعرض دروسها",
                    style:
                        theme.textTheme.bodyLarge!.copyWith(color: Colors.grey),
                  ),
                ),
              ),

            // 🔹 تفاصيل الدرس
            if (selectedLesson != null)
              Expanded(
                child: SingleChildScrollView(
                  child: LessonContentWidget(selectedLesson: selectedLesson),
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Text(
                    "اختر درساً لعرض محتواه وأسئلته",
                    style:
                        theme.textTheme.bodyLarge!.copyWith(color: Colors.grey),
                  ),
                ),
              ),

            // ✅ الزر الثابت في الأسفل للانتقال لصفحة الأسئلة
            if (selectedLesson != null)
              Padding(
                padding:
                    const EdgeInsets.only(left: 150, right: 16, bottom: 16),
                child: OutlinedButton(
                  onPressed: () {
                    Get.to(() => QuestionsPage(
                          lessonId: selectedLesson.id,
                          lessonName: selectedLesson.title,
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text("الأسئلة"),
                ),
              )
          ],
        );
      }),

      // ✅ زر الإضافة العائم
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.showAddDialogOptions(context),
        label: const Text("إضافة"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
