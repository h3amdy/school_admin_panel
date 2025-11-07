import 'package:ashil_school/features/curriculum/controllers/curriculum_controller.dart';
import 'package:ashil_school/features/curriculum/views/widgets/curriculum_filter_dropdowns.dart';
import 'package:ashil_school/features/curriculum/views/widgets/subject_grid.dart';
import 'package:ashil_school/features/grade/views/dialog/add_edit_dialog.dart';
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
      
      // [NEW] 2. التعامل مع حالة انتظار تحميل الصفوف (البيانات الأولية)
      if (controller.gradeController.isLoading.value || controller.currentGrade.value == null) {
        return Scaffold(
          appBar: AppBar(title: const Text("المنهج")),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      // [NEW] 3. التعامل مع حالة "لا توجد صفوف"
      if (controller.currentGrade.value!.id == 'none') {
        return Scaffold(
          appBar: AppBar(title: const Text("المنهج")),
          body: const Center(child: Text("الرجاء إضافة صف دراسي أولاً.")),
        );
      }

      final gradeController = controller.gradeController; 
      final currentGrade = controller.currentGrade.value!;
      
      // [NEW] 4. التحقق من حالة "لا توجد فصول" (إصلاح مشكلة الدوران)
      final hasNoSemesters = !controller.isLoadingSemesters.value && controller.semesters.isEmpty;

      // 5. عرض الواجهة الطبيعية عند توفر البيانات
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("منهج ${currentGrade.name}"),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 6. قائمة الصفوف والفصول المنسدلة
                CurriculumFilterDropdowns(
                  controller: controller, 
                  allGrades: gradeController.grades,
                  selectedGrade: currentGrade, // أصبح مضموناً أنه ليس null هنا
                  onGradeSelected: (newGrade) {
                    controller.changeGrade(newGrade);
                  },
                  onAddGrade: () => showAddEditGradeDialog(
                      context, gradeController,
                      grade: null),
                ),

                const SizedBox(height: 16),
                
                // 7. منطقة عرض المواد (تعتمد على حالة الفصول والمواد)
                Expanded(
                  child: Obx(() {
                    
                    // [MODIFIED] 7a. عرض رسالة "لا توجد فصول"
                    if (hasNoSemesters) {
                        return Center(child: Text("لا توجد فصول في صف ${currentGrade.name}."));
                    }
                    
                    // 7b. إظهار التحميل أو شبكة المواد
                    if (controller.isLoadingSubjects.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    return SubjectGrid(
                      controller: controller.subjectController,
                      gradeName: currentGrade.name,
                      selectedSemester: controller.selectedSemester,
                    );
                  }),
                ),
              ],
            ),
          ),

          floatingActionButton: Obx(() {
            // [MODIFIED] لا يظهر الزر إذا لم يكن هناك فصل مختار أو لا توجد فصول أصلاً
            if (controller.selectedSemester.value == null || hasNoSemesters) {
              return const SizedBox.shrink();
            }
            return FloatingActionButton.extended(
              onPressed: () => showAddEditSubjectDialog(
                controller: controller.subjectController, 
                selectedSemester: controller.selectedSemester,
                gradeName: currentGrade.name,
              ),
              label:
                  const Text("إضافة مادة", style: TextStyle(color: Colors.white)),
              icon: const Icon(Icons.add, color: Colors.white),
            );
          }),
        ),
      );
    });
  }
}