import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:ashil_school/Utils/custom_dilog/cusom_dilog.dart';
import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/features/unit/controllers/unit_controller.dart';
import 'package:ashil_school/features/unit/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnitDialog extends StatefulWidget {
  final UnitController unitController;
  final UnitModel? unitToEdit;

  const UnitDialog({
    super.key,
    required this.unitController,
    this.unitToEdit,
  });

  @override
  State<UnitDialog> createState() => _UnitDialogState();
}

class _UnitDialogState extends State<UnitDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.unitToEdit != null) {
      widget.unitController.prepareForEdit(widget.unitToEdit!);
    } else {
      widget.unitController.prepareForAdd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.unitToEdit != null;
    final dialogTitle = isEditing ? "✏️ تعديل الوحدة" : " إضافة وحدة جديدة";
    final buttonText = isEditing ? "حفظ" : "إضافة";
    final unitController = widget.unitController;

    return CustomDialog(
      title: dialogTitle,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: unitController.nameController,
                decoration: const InputDecoration(labelText: "اسم الوحدة"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال اسم الوحدة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: KSizes.spaceBewItems),
              TextFormField(
                controller: unitController.descriptionController,
                decoration:
                    const InputDecoration(labelText: "وصف الوحدة (اختياري)"),
                maxLines: 3,
              ),
              const SizedBox(height: KSizes.spaceBewItems),
              TextFormField(
                controller: unitController.orderController,
                // ✅ هنا تم حذف (اختياري)
                decoration: const InputDecoration(labelText: "ترتيب الوحدة"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  // ✅ هنا أصبح التحقق إجبارياً
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال رقم الترتيب';
                  }
                  if (int.tryParse(value) == null) {
                    return 'الرجاء إدخال رقم صحيح للترتيب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: KSizes.spaceBewItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: KColors.warning)),
                    child: const Text("إلغاء"),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                    ),
                    child: Text(buttonText),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (isEditing) {
                          unitController.updateUnit(widget.unitToEdit!.id);
                        } else {
                          unitController.addUnit();
                        }
                        Get.back();
                      } else {
                        KLoaders.error(
                            title: "خطأ",
                            message: "الرجاء مراجعة البيانات المدخلة");
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
