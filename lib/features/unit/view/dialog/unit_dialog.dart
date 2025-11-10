import 'package:ashil_school/Utils/custom_dilog/custom_dialog.dart';
import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/features/unit/controllers/unit_controller.dart';
import 'package:ashil_school/features/unit/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnitDialog extends StatefulWidget {
  final UnitController unitController;
  final UnitModel? unitToEdit;
  final VoidCallback? onUnitAddedCallback; // [NEW]

  const UnitDialog({
    super.key,
    required this.unitController,
    this.unitToEdit,
    this.onUnitAddedCallback, // [NEW]
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
    final title = isEditing ? "تعديل الوحدة" : "إضافة وحدة جديدة";
    final buttonText = isEditing ? "حفظ التعديلات" : "إضافة";
    final unitController = widget.unitController;

    return CustomDialog(
      title: title,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: unitController.nameController,
                      decoration: const InputDecoration(labelText: "اسم الوحدة"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال اسم الوحدة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: unitController.orderController,
                      decoration: const InputDecoration(labelText: "ترتيب الوحدة"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال ترتيب الوحدة';
                        }
                        if (int.tryParse(value) == null) {
                          return 'يرجى إدخال رقم صحيح للترتيب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: unitController.descriptionController,
                      decoration: const InputDecoration(labelText: "وصف الوحدة (اختياري)"),
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  child: const Text("إلغاء"),
                  onPressed: () => Get.back(),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (isEditing) {
                        unitController.updateUnit(widget.unitToEdit!.id);
                      } else {
                        // [MODIFIED] تمرير الـ Callback
                        unitController.addUnit(
                            onUnitAddedCallback: widget.onUnitAddedCallback);
                      }
                      Get.back();
                    } else {
                      KLoaders.error(
                          title: "خطأ",
                          message: "الرجاء مراجعة البيانات المدخلة");
                    }
                  },
                  child: Text(buttonText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}