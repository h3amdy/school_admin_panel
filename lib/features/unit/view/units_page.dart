// lib/UI/unit/units_ui.dart
import 'package:ashil_school/features/unit/controllers/unit_controller.dart';
import 'package:ashil_school/features/unit/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnitsPage extends StatelessWidget {
  final String subjectId;
  final String subjectName;
  final UnitController controller;

  UnitsPage({
    super.key,
    required this.subjectId,
    required this.subjectName,
  }) : controller = Get.put(UnitController(subjectId: subjectId));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("وحدات مادة: $subjectName"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null) {
          return Center(
            child: Text(
              controller.error.value!,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          );
        }

        final units = controller.units;
        if (units.isEmpty) {
          return const Center(child: Text("لا يوجد وحدات لهذه المادة."));
        }

        return ListView.builder(
          itemCount: units.length,
          itemBuilder: (context, index) {
            final unit = units[index];
            return Card(
              child: ListTile(
                onTap: () {
                  // Get.to(
                  //     () => LessonsPage(unitId: unit.id, unitName: unit.name));
                },
                title: Text(unit.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showAddEditDialog(context, unit),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteUnit(unit.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context, null),
        tooltip: "إضافة وحدة جديدة",
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, UnitModel? unit) {
    final nameController = TextEditingController(text: unit?.name ?? "");
    Get.dialog(
      AlertDialog(
        title: Text(unit == null ? "إضافة وحدة جديدة" : "تعديل الوحدة"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "اسم الوحدة"),
        ),
        actions: [
          TextButton(
            child: const Text("إلغاء"),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            child: Text(unit == null ? "إضافة" : "حفظ"),
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                if (unit == null) {
                  //  controller.addUnit(name: name);
                } else {
                  // TODO: أضف دالة تعديل الوحدة في الكنترولر والمسار
                  // controller.updateUnit(unit.id, name: name);
                }
                Get.back();
              } else {
                Get.snackbar("خطأ", "الرجاء إدخال اسم الوحدة.");
              }
            },
          ),
        ],
      ),
    );
  }
}
