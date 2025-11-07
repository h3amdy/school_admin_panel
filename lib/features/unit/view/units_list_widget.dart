import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/Utils/theme/decorations/app_decorations.dart';
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
    final theme = Theme.of(context);

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
          padding: EdgeInsets.symmetric(horizontal: KSizes.md),
          scrollDirection: Axis.horizontal,
          itemCount: unitController.units.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final unit = unitController.units[index];
            final isSelected = unitController.selectedUnit.value?.id == unit.id;
            return _unitItem(context, unit, isSelected, theme);
          },
        ),
      );
    });
  }

  Widget _unitItem(
    BuildContext context,
    UnitModel unit,
    bool isSelected,
    ThemeData theme,
  ) {
    final primary = theme.primaryColor;

    return GestureDetector(
      onLongPress: () => showEditDeleteOptions(
        onEdit: () {
          Get.dialog(UnitDialog(
            unitController: unitController,
            unitToEdit: unit,
          ));
        },
        onDelete: () => showConfirmationDialog(
          onCancel: () => Get.back(),
          title: "حذف الوحدة",
          message: "هل أنت متأكد من حذف هذه الوحدة وجميع دروسها؟",
          onConfirm: () {
            unitController.deleteUnit(unit.id);
            Get.back();
          },
        ),
      ),
      onTap: () => unitController.selectUnit(unit),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration:
                AppDecorations.cardDecoration(context, selected: isSelected),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.folder_rounded,
                  color: isSelected ? Colors.white : primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  unit.name,
                  style: theme.textTheme.titleMedium!
                      .copyWith(color: isSelected ? Colors.white : null),
                ),
              ],
            ),
          ),

          /// رقم الترتيب في الزاوية
          if (unit.order != null)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: Text(
                  unit.order.toString(),
                  style: TextStyle(
                    color: isSelected ? primary : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
