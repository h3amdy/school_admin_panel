import 'package:ashil_school/features/lesson/view/widgets/lesson_grid.dart';
import 'package:ashil_school/features/subject/controllers/subject_details_controller.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [NEW] 1. حقل البحث وزر الفلترة
            _buildSearchAndFilter(context, controller),

            const Divider(height: 1),

            // [MODIFIED] 2. شبكة الدروس (تعتمد على filteredLessons)
            Expanded(
              child: Obx(() {
                if (controller.isLoadingLessons.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredLessons.isEmpty) {
                  return Center(
                    child: Text(
                      controller.searchController.text.isNotEmpty
                          ? "لا توجد نتائج بحث مطابقة"
                          : "لا توجد دروس لعرضها (قم بإضافة درس أو تعديل الفلتر)",
                      style: theme.textTheme.bodyLarge!
                          .copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // استخدام شبكة الدروس
                return LessonGrid(
                  lessons: controller.filteredLessons,
                  subjectDetailsController: controller,
                );
              }),
            ),
          ],
        ),
      ),

      // [MODIFIED] 3. الزر العائم (أصبح لإضافة درس)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.showAddEditLessonDialog(context),
        label: const Text("إضافة درس"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  /// [NEW] ويدجت شريط البحث والفلترة
  Widget _buildSearchAndFilter(
      BuildContext context, SubjectDetailsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // 1. حقل البحث
          Expanded(
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "ابحث عن درس...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).disabledColor.withOpacity(0.1),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 2. زر الفلترة
          Obx(() => IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: controller.filterUnits.isEmpty
                      ? Theme.of(context).disabledColor.withOpacity(0.2)
                      : Theme.of(context).primaryColor,
                  foregroundColor: controller.filterUnits.isEmpty
                      ? Theme.of(context).iconTheme.color
                      : Colors.white,
                ),
                icon: Icon(controller.filterUnits.isEmpty
                    ? Icons.filter_list_off
                    : Icons.filter_list),
                onPressed: () => _showFilterBottomSheet(context, controller),
              )),
        ],
      ),
    );
  }

  /// [NEW] إظهار BottomSheet للفلترة بالوحدات
  void _showFilterBottomSheet(
      BuildContext context, SubjectDetailsController controller) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.5,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text("فلترة حسب الوحدة",
                style: Theme.of(context).textTheme.headlineSmall),
            const Divider(),
            ListTile(
              title: const Text("عرض كل الدروس"),
              trailing: Obx(() => Radio(
                    value: controller.filterUnits.isEmpty,
                    groupValue: true,
                    onChanged: (value) {
                      controller.clearUnitFilters();
                    },
                  )),
              onTap: () {
                controller.clearUnitFilters();
              },
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.units.length,
                    itemBuilder: (context, index) {
                      final unit = controller.units[index];
                      // استخدام Obx فردي لكل عنصر لضمان تحديثه
                      return Obx(() {
                        final isSelected =
                            controller.filterUnits.any((u) => u.id == unit.id);
                        return CheckboxListTile(
                          title: Text(unit.name),
                          value: isSelected,
                          onChanged: (bool? value) {
                            if (value != null) {
                              controller.toggleUnitFilter(unit, value);
                            }
                          },
                        );
                      });
                    },
                  )),
            ),
            ElevatedButton(
              child: const Text("تطبيق الفلتر"),
              onPressed: () => Get.back(),
            )
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}