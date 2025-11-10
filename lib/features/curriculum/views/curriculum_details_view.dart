import 'package:ashil_school/features/curriculum/controllers/curriculum_controller.dart';
import 'package:ashil_school/features/curriculum/views/widgets/curriculum_filter_dropdowns.dart';
import 'package:ashil_school/features/curriculum/views/widgets/subject_grid.dart';
import 'package:ashil_school/features/grade/views/dialog/add_edit_dialog.dart';
import 'package:ashil_school/features/semester/views/dialogs/add_edit_semester_dialog.dart'; // [NEW] 1. إضافة الإمبورت
import 'package:ashil_school/features/subject/views/dialogs/add_edit_subject_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurriculumPage extends StatelessWidget {
  const CurriculumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CurriculumController());

    // 1. تغليف كل شيء بـ Obx للتعامل مع حالة التحميل الأولية
    return Obx(() {
      // 2. التعامل مع حالة انتظار تحميل الصفوف (البيانات الأولية)
      if (controller.gradeController.isLoading.value ||
          controller.currentGrade.value == null) {
        return Scaffold(
          appBar: AppBar(title: const Text("المنهج")),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      // 3. التعامل مع حالة "لا توجد صفوف"
      // (ملاحظة: الزر العائم سيتعامل مع هذا أيضاً)
      final hasNoGrades = controller.currentGrade.value!.id == 'none';

      // 4. التحقق من حالة "لا توجد فصول" (إصلاح مشكلة الدوران)
      final hasNoSemesters =
          !controller.isLoadingSemesters.value && controller.semesters.isEmpty;

      // 5. عرض الواجهة الطبيعية عند توفر البيانات
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("منهج ${controller.currentGrade.value!.name}"),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 6. قائمة الصفوف والفصول المنسدلة
                // (لا نعرضها إذا لم يكن هناك صفوف أصلاً)
                if (!hasNoGrades)
                  CurriculumFilterDropdowns(
                    controller: controller,
                    allGrades: controller.gradeController.grades,
                    selectedGrade: controller.currentGrade.value!,
                    onGradeSelected: (newGrade) {
                      controller.changeGrade(newGrade);
                    },
                    onAddGrade: () => showAddEditGradeDialog(
                        context, controller.gradeController,
                        grade: null),
                  ),

                const SizedBox(height: 16),

                // 7. منطقة عرض المواد (تعتمد على حالة الفصول والمواد)
                Expanded(
                  child: Obx(() {
                    // 7a. عرض رسالة "لا توجد فصول"
                    if (hasNoSemesters && !hasNoGrades) {
                      return Center(
                          child: Text(
                              "لا توجد فصول في صف ${controller.currentGrade.value!.name}."));
                    }

                    // 7b. عرض رسالة "لا توجد صفوف"
                    if (hasNoGrades) {
                      return const Center(
                          child: Text("الرجاء إضافة صف دراسي أولاً."));
                    }

                    // 7c. إظهار التحميل أو شبكة المواد
                    if (controller.isLoadingSubjects.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return SubjectGrid(
                      controller: controller.subjectController,
                      gradeName: controller.currentGrade.value!.name,
                      selectedSemester: controller.selectedSemester,
                    );
                  }),
                ),
              ],
            ),
          ),

          // [MODIFIED] 8. الزر العائم الذكي (Smart FAB)
          floatingActionButton: Obx(() {
            final gradeController = controller.gradeController;
            final currentGrade = controller.currentGrade.value!; // آمن هنا
            final hasSelectedSemester =
                controller.selectedSemester.value != null;

            if (hasNoGrades) {
              // --- الحالة 1: لا توجد صفوف ---
              return FloatingActionButton.extended(
                onPressed: () => showAddEditGradeDialog(
                    context, gradeController,
                    grade: null),
                label: const Text("إضافة صف"),
                icon: const Icon(Icons.add),
              );
            }

            if (!hasSelectedSemester && hasNoSemesters) {
              // --- الحالة 2: يوجد صف، ولكن لا توجد فصول ---
              return FloatingActionButton.extended(
                onPressed: () => showAddEditSemesterDialog(
                  controller: controller.semesterController,
                  gradeName: currentGrade.name,
                ),
                label: const Text("إضافة فصل"),
                icon: const Icon(Icons.add),
              );
            }

            if (hasSelectedSemester) {
              // --- الحالة 3: يوجد صف وفصل (الحالة الطبيعية) ---
              return FloatingActionButton.extended(
                onPressed: () => showAddEditSubjectDialog(
                  controller: controller.subjectController,
                  selectedSemester: controller.selectedSemester,
                  gradeName: currentGrade.name,
                ),
                label: const Text("إضافة مادة",
                    style: TextStyle(color: Colors.white)),
                icon: const Icon(Icons.add, color: Colors.white),
              );
            }

            // الحالة الافتراضية (أثناء تحميل الفصول)
            return const SizedBox.shrink();
          }),
        ),
      );
    });
  }
}
