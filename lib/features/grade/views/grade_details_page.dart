import 'package:ashil_school/features/semester/views/semester_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/common/widgets/section_heading.dart';
import 'package:ashil_school/features/grade/controllers/grade_details_controller.dart';
import 'package:ashil_school/features/subject/views/subject_grid.dart';

class GradeDetailsPage extends StatelessWidget {
  final String gradeId;
  final String gradeName;

  const GradeDetailsPage({
    super.key,
    required this.gradeId,
    required this.gradeName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GradeDetailsController(gradeId));

    return Scaffold(
      appBar: AppBar(
        title: Text("فصول ومواد صف: $gradeName"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          KSectionHeading(title: "الفصول"),
          SemesterList(
            controller: controller.semesterController,
            selectedSemester: controller.selectedSemester,
            onSelect: controller.selectSemester,
           gradeName:gradeName
          ),
          const Divider(height: 1),
          KSectionHeading(title: "المواد"),
          SubjectGrid(controller: controller.subjectController,gradeName: gradeName,),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            controller.showAddDialogOptions(context, gradeName: gradeName),
        label: const Text("إضافة"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
