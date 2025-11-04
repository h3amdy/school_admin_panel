import 'package:ashil_school/features/grade/controllers/curriculum_controller.dart';
import 'package:ashil_school/features/grade/controllers/grade_controller.dart';
import 'package:ashil_school/features/grade/models/grade.dart';
import 'package:ashil_school/features/grade/views/dialog/add_edit_dialog.dart';
import 'package:ashil_school/features/grade/views/widgets/curriculum_filter_dropdowns.dart';
import 'package:ashil_school/features/grade/views/widgets/subject_grid.dart';
import 'package:ashil_school/features/subject/views/dialogs/add_edit_subject_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurriculumPage extends StatelessWidget {
  final String gradeId;
  final String gradeName;

  const CurriculumPage({
    super.key,
    required this.gradeId,
    required this.gradeName,
  });

  @override
  Widget build(BuildContext context) {
    // 1. العثور على متحكم الصفوف العام
    final gradeController = Get.find<GradeController>();

    // 2. العثور على المودل الأولي للصف
    //    (هذا الكود يمكن أن يفشل إذا تم فتح الصفحة قبل تحميل الصفوف)
    final initialGrade =
        gradeController.grades.firstWhereOrNull((g) => g.id == gradeId) ??
            GradeModel(id: gradeId, name: gradeName, order: 0); // كاحتياط

    // 3. وضع المتحكم الخاص بالصفحة في الذاكرة
    //    نستخدم fenix: true لضمان عدم حذفه إذا انتقلنا مؤقتاً
    final controller = Get.put(
      CurriculumController(initialGrade: initialGrade),
      // لا نحتاج tag هنا لأنه متحكم خاص بهذه الصفحة فقط
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          // 4. جعل العنوان مُتفاعل (Reactive)
          title: Obx(() => Text("منهج ${controller.currentGrade.value.name}")),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 5. منطقة الفلاتر (تعتمد بالكامل على gradeController و controller)
              Obx(() {
                return CurriculumFilterDropdowns(
                  controller: controller, // تمرير المتحكم الجديد
                  allGrades: gradeController.grades, // قائمة الصفوف الكاملة
                  selectedGrade:
                      controller.currentGrade.value, // الصف المختار حالياً

                  // 6. هذا هو التعديل الأهم:
                  onGradeSelected: (newGrade) {
                    // تحديث الحالة بدلاً من التنقل
                    controller.changeGrade(newGrade);
                  },
                  onAddGrade: () => showAddEditGradeDialog(
                      context, gradeController,
                      grade: null),
                );
              }),

              const SizedBox(height: 16),

              // 7. شبكة عرض المواد (تعتمد بالكامل على controller)
              Expanded(
                // استخدام Expanded ليأخذ باقي المساحة
                child: Obx(() {
                  // إظهار تحميل أو شبكة المواد
                  if (controller.isLoadingSubjects.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // يتم تمرير متحكم المواد الفرعي من المتحكم الرئيسي
                  return SubjectGrid(
                    controller: controller.subjectController,
                    gradeName: controller.currentGrade.value.name,
                    selectedSemester: controller.selectedSemester,
                  );
                }),
              ),
            ],
          ),
        ),

        // 8. الزر العائم (يعتمد بالكامل على controller)
        floatingActionButton: Obx(() {
          if (controller.selectedSemester.value == null) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            onPressed: () => showAddEditSubjectDialog(
              controller: controller.subjectController, // المتحكم الفرعي
              selectedSemester: controller.selectedSemester,
              gradeName: controller.currentGrade.value.name,
            ),
            label:
                const Text("إضافة مادة", style: TextStyle(color: Colors.white)),
            icon: const Icon(Icons.add, color: Colors.white),
          );
        }),
      ),
    );
  }
}
