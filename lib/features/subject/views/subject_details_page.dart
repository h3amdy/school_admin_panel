import 'package:ashil_school/common/widgets/custom_dropdown.dart';
import 'package:ashil_school/features/lesson/controller/lesson_controller.dart';
import 'package:ashil_school/features/lesson/view/widgets/lesson_grid.dart';
import 'package:ashil_school/features/subject/controllers/subject_details_controller.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:ashil_school/features/unit/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectDetailsPage extends StatelessWidget {
  final SubjectModel subject;

  const SubjectDetailsPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubjectDetailsController(subject));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("📘 ${subject.name}"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        // [NEW] - إضافة SafeArea
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [MODIFIED] 1. قائمة الوحدات (أصبحت قائمة منسدلة)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Obx(() {
                if (controller.isLoadingUnits.value) {
                  return const Center(child: LinearProgressIndicator());
                }
                return CustomDropdown<UnitModel>(
                  items: controller.units,
                  selectedItem: controller.selectedUnit.value,
                  itemAsString: (unit) => unit.name,
                  onChanged: (newValue) {
                    controller.selectUnit(newValue);
                  },
                  hintText: "اختر وحدة دراسية",
                  onAddPressed: () => controller.showAddEditUnitDialog(context),
                );
              }),
            ),

            const Divider(height: 1),

            // [MODIFIED] 2. شبكة الدروس (بدلاً من القائمة والمحتوى)
            Expanded(
              child: Obx(() {
                final selectedUnit = controller.selectedUnit.value;

                if (selectedUnit == null) {
                  // إذا لم يتم اختيار وحدة
                  return Center(
                    child: Text(
                      "اختر وحدة لعرض دروسها",
                      style: theme.textTheme.bodyLarge!
                          .copyWith(color: Colors.grey),
                    ),
                  );
                }

                // إذا تم اختيار وحدة، ابحث عن متحكم الدروس الخاص بها
                if (!Get.isRegistered<LessonController>(tag: selectedUnit.id)) {
                  // هذا قد يحدث للحظة قبل أن يقوم المستمع بإنشاء المتحكم
                  return const Center(child: CircularProgressIndicator());
                }

                final lessonController =
                    Get.find<LessonController>(tag: selectedUnit.id);

                // استخدام شبكة الدروس الجديدة
                return LessonGrid(
                  lessonController: lessonController,
                  subjectDetailsController: controller,
                  unitName: selectedUnit.name,
                );
              }),
            ),

            // [REMOVED] - تم حذف زر "الأسئلة" الثابت
          ],
        ),
      ),

      // [MODIFIED] 3. الزر العائم (أصبح لإضافة درس)
      floatingActionButton: Obx(() {
        // لا تظهر الزر إلا إذا تم اختيار وحدة
        if (controller.selectedUnit.value == null) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: () => controller.showAddEditLessonDialog(null),
          label: const Text("إضافة درس"),
          icon: const Icon(Icons.add),
        );
      }),
    );
  }
}
