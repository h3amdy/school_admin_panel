// lib/features/teacher/teachers_page.dart

import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:ashil_school/features/teacher/controllers/teacher_controller.dart';
import 'package:ashil_school/features/teacher/view/dialogs/add_edit_teacher_dialog.dart';
import 'package:ashil_school/models/user_model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeachersPage extends StatelessWidget {
  final TeacherController controller = Get.put(TeacherController());
  TeachersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("إدارة المعلمين"),
        centerTitle: true,
        actions: [
          Obx(() => IconButton(
                tooltip: "مزامنة",
                icon: controller.isSyncing.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator.adaptive(strokeWidth: 3),
                      )
                    : const Icon(Icons.sync),
                onPressed: controller.isSyncing.value
                    ? null
                    : () => controller.syncAll(), // ✅ استدعاء دالة syncAll
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null) {
          return Center(
            child: Text(
              controller.error.value!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          );
        }

        final teachers = controller.teachers;
        if (teachers.isEmpty) {
          return const Center(child: Text("لا يوجد معلمين بعد"));
        }
        return ListView.separated(
          itemCount: teachers.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final teacher = teachers[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child: Text(
                    teacher.fullName?.isNotEmpty == true
                        ? teacher.fullName![0]
                        : "?",
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ),
                title: Text(teacher.fullName ?? ""),
                subtitle: Text(teacher.phone ?? "غير متوفر"),
                trailing: const Icon(Icons.chevron_left),
                onTap: () => _showTeacherDetails(context, teacher),
                onLongPress: () => showEditDeleteOptions(
                    itemName: teacher.fullName,
                    onDelete: () => controller.deleteTeacher(teacher.id),
                    onEdit: () => showAddEditTeacherDialog(context,
                        teacher: teacher, controller: controller)),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            // () => Get.to(() => LessonEditorView()),
            //  () => Get.to(() => LessonAddView()),
            () => showAddEditTeacherDialog(context, controller: controller),
        icon: const Icon(Icons.person_add),
        label: const Text("إضافة معلم"),
      ),
    );
  }

  void _showTeacherDetails(BuildContext context, User teacher) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          teacher.fullName ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              icon: Icons.phone,
              label: "الهاتف",
              value: teacher.phone ?? "غير متوفر",
            ),
            _buildDetailRow(
              icon: Icons.school,
              label: "التخصص",
              value: teacher.specialization ?? "غير محدد",
            ),
            _buildDetailRow(
              icon: Icons.book,
              label: "المواد",
              value: _subjectsNames(teacher.assignedSubjects ?? [],
                  controller.allAvailableSubjects),
            ),
            _buildDetailRow(
              icon: Icons.sync,
              label: "المزامنة",
              value: teacher.isSynced == true ? "متزامن ✅" : "غير متزامن ⏳",
            ),
            const Divider(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("إغلاق"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _subjectsNames(
      List<String> ids, List<SubjectModel> allAvailableSubjects) {
    final filteredSubjects = allAvailableSubjects
        .where((s) => ids.contains(s.id))
        .map((s) => s.name)
        .toList();
    if (filteredSubjects.isEmpty) {
      return "لا يوجد";
    }
    return filteredSubjects.join(", ");
  }
}
