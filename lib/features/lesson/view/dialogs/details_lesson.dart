import 'dart:io';
import 'package:ashil_school/common/widgets/custom_dropdown.dart';
import 'package:ashil_school/common/widgets/image_screen.dart';
import 'package:ashil_school/features/lesson/controllers/add_edit_lesson_controller.dart';
import 'package:ashil_school/features/unit/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DetailsFormBody extends StatelessWidget {
  final AddEditLessonController controller;
  const DetailsFormBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.detailFormKey,
      autovalidateMode: controller.detailAutovalidateMode.value,
      child: Obx(() => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // صورة البروفايل
                _buildProfileImagePicker(context, controller),
                const SizedBox(height: 24),

                // اختيار الوحدة
                CustomDropdown<UnitModel>(
                  items: controller.subjectController.units,
                  selectedItem: controller.selectedUnit.value,
                  itemAsString: (u) => u.name,
                  onChanged: (u) => controller.selectedUnit.value = u,
                  hintText: "اختر الوحدة",
                  onAddPressed: () {
                    controller.subjectController.showAddEditUnitDialog(
                      context,
                      onUnitAdded: () {
                        final newUnit = controller.subjectController
                            .unitController.selectedUnit.value;
                        if (newUnit != null)
                          controller.selectedUnit.value = newUnit;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // اسم الدرس
                TextFormField(
                  controller: controller.titleController,
                  decoration: const InputDecoration(
                    labelText: "اسم الدرس",
                    prefixIcon: Icon(Iconsax.text),
                  ),
                  validator: (v) => (v == null || v.trim().length < 3)
                      ? 'الاسم يجب أن يكون 3 أحرف على الأقل'
                      : null,
                ),
                const SizedBox(height: 16),

                // ترتيب الدرس
                TextFormField(
                  controller: controller.orderController,
                  decoration: const InputDecoration(
                    labelText: "ترتيب الدرس",
                    prefixIcon: Icon(Iconsax.sort),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'الرجاء إدخال الترتيب';
                    if (int.tryParse(v) == null) return 'رقم غير صحيح';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // أزرار أسفل الحوار
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Iconsax.close_circle),
                        label: const Text('إغلاق'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Iconsax.tick_circle),
                        label: const Text('تم'),
                        onPressed: () {
                          if (controller.detailFormKey.currentState!
                              .validate()) {
                            Navigator.of(context).pop(); // أغلق الحوار
                          } else {
                            controller.detailAutovalidateMode.value =
                                AutovalidateMode.always;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildProfileImagePicker(
      BuildContext context, AddEditLessonController controller) {
    final imagePath = controller.profileImage.value;
    final colorScheme = Theme.of(context).colorScheme;

    Widget imageWidget;
    if (imagePath != null && imagePath.startsWith('http')) {
      // صورة من الشبكة
      imageWidget = Image.network(imagePath, fit: BoxFit.cover);
    } else if (imagePath != null) {
      // صورة محلية
      imageWidget = InkWell(
          onTap: () => Get.to(() => ImageScreen(
                image: File(imagePath),
              )),
          child: Image.file(File(imagePath), fit: BoxFit.cover));
    } else {
      // لا يوجد صورة
      imageWidget = Icon(Iconsax.camera, size: 40, color: colorScheme.primary);
    }

    return Center(
      child: InkWell(
        onTap: controller.pickProfileImage,
        borderRadius: BorderRadius.circular(75),
        child: Stack(
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.primary, width: 2),
                color: colorScheme.primaryContainer.withOpacity(0.3),
              ),
              clipBehavior: Clip.antiAlias,
              child: Center(child: imageWidget),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Iconsax.edit, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
