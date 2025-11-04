import 'package:ashil_school/features/grade/controllers/grade_details_controller.dart';
import 'package:ashil_school/features/subject/views/dialogs/add_edit_subject_dialog.dart';
import 'package:ashil_school/features/subject/views/widgets/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/features/subject/controllers/subject_controller.dart';
import 'package:ashil_school/features/subject/views/subject_details_ui.dart';

class SubjectGrid extends StatelessWidget {
  final SubjectController controller;
 final String? gradeName;
  const SubjectGrid({super.key, required this.controller,   this.gradeName});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.semesterId == null) {
        return const Expanded(
          child: Center(child: Text("الرجاء اختيار فصل لعرض المواد")),
        );
      }

      if (controller.isLoading.value) {
        return const Expanded(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.subjects.isEmpty) {
        return const Expanded(
          child: Center(child: Text("لا يوجد مواد في هذا الفصل.")),
        );
      }

      return Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: controller.subjects.length,
          itemBuilder: (context, index) {
            final subject = controller.subjects[index];
            return SubjectCard(
              subject: subject,
              onTap: () {
                Get.to(() => SubjectDetailsPage(subject: subject));
              },
              onEdit: () {
                final  GradeDetailsController gradeDCtrl=Get.find(tag:controller.gradeId );
                showAddEditSubjectDialog(
                controller: controller,
               selectedSemester: gradeDCtrl.selectedSemester,
                subject: subject,
                gradeName:gradeName,
              );
              },
              onDelete: () => showConfirmationDialog(
                onCancel: () => Get.back(),
                title: "حذف المادة",
                message: "هل أنت متأكد من حذف مادة ${subject.name}؟",
                onConfirm: () => controller.deleteSubject(subject.id),
              ),
            );
          },
        ),
      );
    });
  }
}
