import 'package:ashil_school/features/semester/views/dialogs/add_edit_semester_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/features/semester/controllers/semester_controller.dart';
import 'package:ashil_school/features/semester/models/semester.dart';

class SemesterList extends StatelessWidget {
  final SemesterController controller;
  final Rx<SemesterModel?> selectedSemester;
  final Function(SemesterModel) onSelect;
  final String? gradeName;
  const SemesterList(
      {super.key,
      required this.controller,
      required this.selectedSemester,
      required this.onSelect,
      this.gradeName});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: LinearProgressIndicator());
      }
      if (controller.semesters.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text("لا يوجد فصول لهذا الصف.")),
        );
      }

      return SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: controller.semesters.length,
          itemBuilder: (context, index) {
            final semester = controller.semesters[index];

            return GestureDetector(
              onLongPress: () {
                showEditDeleteOptions(
                  itemName: semester.name,
                  onEdit: () => showAddEditSemesterDialog(
                      controller: controller,
                      semester: semester,
                      gradeName: gradeName),
                  onDelete: () => controller.deleteSemester(semester.id),
                );
              },
              onTap: () => onSelect(semester),
              child: Obx(() {
                final isSelected = selectedSemester.value?.id == semester.id;
                return Card(
                  elevation: isSelected ? 4 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: isSelected
                        ? BorderSide(
                            color: Theme.of(context).primaryColor, width: 2)
                        : BorderSide.none,
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            semester.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          if (isSelected) const SizedBox(width: 8),
                          if (isSelected)
                            Icon(Icons.check_circle,
                                color: Theme.of(context).primaryColor),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      );
    });
  }
}
