// lib/features/teacher/view/subjects_assignment_dialog.dart
import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:ashil_school/Utils/custom_dilog/cusom_dilog.dart';
import 'package:ashil_school/Utils/theme/decorations/app_decorations.dart';
import 'package:ashil_school/features/grade/models/grade.dart';
import 'package:ashil_school/features/semester/models/semester.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:ashil_school/features/teacher/controllers/subject_assignment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectsAssignmentDialog extends StatelessWidget {
  final Function(List<String>) onSave;
  final List<String> initialSelectedSubjectIds;

  const SubjectsAssignmentDialog({
    super.key,
    required this.onSave,
    required this.initialSelectedSubjectIds,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubjectAssignmentController(
      initialSelectedSubjectIds: initialSelectedSubjectIds,
    ));

    return CustomDialog(
      title: 'تحديد المواد المسندة',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // تم تعديل هذا الجزء ليظهر القائمة إذا كانت هناك مواد محددة بالفعل.
          Obx(() {
            final selectedSubjectsWithContext =
                controller.getSelectedSubjectModelsWithContext();

            if (selectedSubjectsWithContext.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              height: 110,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedSubjectsWithContext.length,
                itemBuilder: (context, index) {
                  final data = selectedSubjectsWithContext[index];
                  return _buildAssignedSubjectCard(context, data, controller);
                },
              ),
            );
          }),
          Divider(
            color: context.theme.primaryColor,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (controller.error.value != null) {
                      return SizedBox(
                        height: 100,
                        child: Center(
                          child: Text(
                            controller.error.value!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }
                    if (controller.allGrades.isEmpty) {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: Text("لا توجد صفوف متاحة.")),
                      );
                    }
                    return SizedBox(
                      width: double.maxFinite,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: KSizes.spaceBewItems,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.allGrades.length,
                        itemBuilder: (context, gradeIndex) {
                          final grade = controller.allGrades[gradeIndex];
                          return _buildGradeExpansionTile(
                              context, grade, controller);
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: KColors.warning)),
                onPressed: () => Get.back(),
                child: const Text('إلغاء'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  onSave(controller.selectedSubjectIds.toList());
                  Get.back();
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedSubjectCard(BuildContext context,
      Map<String, dynamic> data, SubjectAssignmentController controller) {
    return Container(
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            color: KColors.primary.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(color: KColors.primary, width: 0.5),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    data['subject']!.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${data['grade']!.name}',
                    style: Theme.of(context).textTheme.labelSmall,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${data['semester']!.name}',
                    style: Theme.of(context).textTheme.labelSmall,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 7,
            right: 7,
            child: GestureDetector(
              onTap: () {
                controller.toggleSubjectSelection(data['subject']!, false);
              },
              child: const Icon(
                Icons.remove_circle,
                color: Colors.red,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeExpansionTile(BuildContext context, GradeModel grade,
      SubjectAssignmentController controller) {
    return Card(
      margin: EdgeInsets.all(0),
      child: ExpansionTile(
        key: PageStorageKey(grade.id),
        title: Row(
          children: [
            Expanded(child: Text('الصف: ${grade.name}')),
            Obx(() {
              controller.selectedSubjectIds.length;
              return Checkbox(
                value: controller.isGradeFullySelected(grade),
                onChanged: (bool? value) {
                  if (value != null) {
                    controller.toggleGradeSelection(grade, value);
                  }
                },
              );
            }),
          ],
        ),
        children: (grade.semesters ?? []).map((semester) {
          return _buildSemesterExpansionTile(context, semester, controller);
        }).toList(),
      ),
    );
  }

  Widget _buildSemesterExpansionTile(BuildContext context,
      SemesterModel semester, SubjectAssignmentController controller) {
    return Card(
      child: ExpansionTile(
        key: PageStorageKey(semester.id),
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              Expanded(child: Text('الفصل: ${semester.name}')),
              Obx(() {
                controller.selectedSubjectIds.length;
                return Checkbox(
                  value: controller.isSemesterFullySelected(semester),
                  onChanged: (bool? value) {
                    if (value != null) {
                      controller.toggleSemesterSelection(semester, value);
                    }
                  },
                );
              }),
            ],
          ),
        ),
        children: (semester.subjects ?? []).map((subject) {
          return _buildSubjectListItem(context, subject, controller);
        }).toList(),
      ),
    );
  }

  Widget _buildSubjectListItem(BuildContext context, SubjectModel subject,
      SubjectAssignmentController controller) {
    return Obx(() {
      controller.selectedSubjectIds.length;
      return Container(
          margin: EdgeInsets.only(bottom: 10, left: 4, right: 4),
          decoration: AppDecorations.cardDecoration(context,
              selected: controller.isSubjectSelected(subject)),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Text(subject.name),
            ),
            trailing: Checkbox(
              value: controller.isSubjectSelected(subject),
              onChanged: (bool? value) {
                if (value != null) {
                  controller.toggleSubjectSelection(subject, value);
                }
              },
            ),
            onTap: () {
              controller.toggleSubjectSelection(
                  subject, !controller.isSubjectSelected(subject));
            },
          ));
    });
  }
}
