// 1. تم تغيير هذا الـ import
import 'package:ashil_school/features/curriculum/controllers/curriculum_controller.dart';
import 'package:ashil_school/features/grade/models/grade.dart';
import 'package:ashil_school/common/widgets/custom_dropdown.dart';
import 'package:ashil_school/features/semester/models/semester.dart';
import 'package:ashil_school/features/semester/views/dialogs/add_edit_semester_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurriculumFilterDropdowns extends StatelessWidget {
  // 2. تم تغيير نوع المتحكم هنا
  final CurriculumController controller;
  final List<GradeModel> allGrades;
  final GradeModel selectedGrade;
  final Function(GradeModel) onGradeSelected;
  final VoidCallback onAddGrade;

  const CurriculumFilterDropdowns({
    super.key,
    required this.controller,
    required this.allGrades,
    required this.selectedGrade,
    required this.onGradeSelected,
    required this.onAddGrade,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          // 1. قائمة الصفوف المنسدلة (Grade Dropdown)
          // (هذه لا تحتاج تعديل لأن بياناتها تُمرر من الـ View)
          Expanded(
            child: CustomDropdown<GradeModel>(
              items: allGrades,
              selectedItem: selectedGrade,
              itemAsString: (grade) => grade.name,
              onChanged: (newValue) {
                onGradeSelected(newValue);
              },
              hintText: "اختر الصف",
              onAddPressed: onAddGrade,
            ),
          ),

          const SizedBox(width: 8), // مسافة فاصلة

          // 2. قائمة الفصول المنسدلة (Semester Dropdown)
          Expanded(
            child: Obx(() {
              // هذه المتغيرات أصبحت تُقرأ من CurriculumDetailsController
              final semesters = controller.semesters;
              final selectedSemester = controller.selectedSemester.value;

              return CustomDropdown<SemesterModel>(
                items: semesters,
                selectedItem: selectedSemester,
                itemAsString: (semester) => semester.name,
                onChanged: (newValue) {
                  controller.selectSemester(newValue);
                },
                hintText: "اختر الفصل",
                onAddPressed: () => showAddEditSemesterDialog(
                  controller: controller.semesterController,
                  // 3. تم تعديل مصدر اسم الصف
                  gradeName: controller.currentGrade.value?.name,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
