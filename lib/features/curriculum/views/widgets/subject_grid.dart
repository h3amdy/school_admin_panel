import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/common/widgets/section_heading.dart';
import 'package:ashil_school/features/curriculum/views/widgets/subject_card.dart';
import 'package:ashil_school/features/semester/models/semester.dart';
import 'package:ashil_school/features/subject/controllers/subject_controller.dart';
import 'package:ashil_school/features/subject/views/dialogs/add_edit_subject_dialog.dart';
import 'package:ashil_school/features/subject/views/subject_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// شبكة عرض المواد (SubjectGrid)
class SubjectGrid extends StatelessWidget {
  final SubjectController controller;
  final String? gradeName;
  final Rx<SemesterModel?> selectedSemester;

  const SubjectGrid(
      {super.key,
      required this.controller,
      this.gradeName,
      required this.selectedSemester});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final semesterName = selectedSemester.value?.name ?? 'اختر فصلاً';

      if (controller.semesterId.value == null) {
        return Center(
            child: Text("الرجاء اختيار فصل لعرض المواد في $gradeName"));
      }

      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.subjects.isEmpty) {
        return Center(child: Text("لا يوجد مواد في فصل $semesterName."));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KSectionHeading(
              title: "مواد الفصل: ${selectedSemester.value?.name ?? ''}"),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // تم تغييرها لعمودين
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8, // تعديل النسبة لتناسب التصميم الجديد
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
                    showAddEditSubjectDialog(
                      controller: controller,
                      selectedSemester: selectedSemester,
                      subject: subject,
                      gradeName: gradeName,
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
          ),
        ],
      );
    });
  }
}
