import 'package:ashil_school/AppResources.dart';
import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/features/unit/models/unit.dart';
import 'package:ashil_school/features/unit/view/dialog/unit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/features/unit/controllers/unit_controller.dart';

class UnitListWidget extends StatelessWidget {
  final UnitController unitController;

  const UnitListWidget({
    super.key,
    required this.unitController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (unitController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (unitController.units.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text("لا توجد وحدات في هذه المادة بعد."),
          ),
        );
      }
      return SizedBox(
        height: 70,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: unitController.units.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final unit = unitController.units[index];
            final isSelected = unitController.selectedUnit.value?.id == unit.id;
            return _unitItem(context, unit, isSelected);
          },
        ),
      );
    });
  }

  Widget _unitItem(BuildContext context, UnitModel unit, bool isSelected) {
    return GestureDetector(
      onLongPress: () => showEditDeleteOptions(
        onEdit: () {
          Get.dialog(UnitDialog(
            unitController: unitController,
            unitToEdit: unit,
          ));

         },
        onDelete: () => showConfirmationDialog(
          // دالة الحذف
          onCancel: () => Get.back(),
          title: "حذف الوحدة",
          message: "هل أنت متأكد من حذف هذه الوحدة وجميع دروسها؟",
          onConfirm: () {
            unitController.deleteUnit(unit.id);
            Get.back();
          },
        ), // استخدام دالة الحذف مباشرة من المتحكم
      ),
      onTap: () => unitController
          .selectUnit(unit), // استخدام دالة الاختيار مباشرة من المتحكم
      child: Card(
        color: isSelected ? secondaryColor : null,
        elevation: isSelected ? 4 : 1,
        child: Padding(
          padding: const EdgeInsets.all(KSizes.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.folder, color: isSelected ? Colors.white : null),
              const SizedBox(width: 6),
              Text(
                unit.name,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: isSelected ? Colors.white : null,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
