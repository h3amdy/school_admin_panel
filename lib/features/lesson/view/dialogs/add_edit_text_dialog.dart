import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:ashil_school/Utils/custom_dilog/custom_dialog.dart';
import 'package:ashil_school/common/widgets/dual_action_duttons.dart';
import 'package:ashil_school/features/lesson/models/content_block.dart';
// افترضتُ هذه المسارات لملفات الويدجت التي طلبتها
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

/// حوار مخصص لإضافة أو تعديل كتلة نصية
///
/// هذا الويدجت هو [StatefulWidget] لإدارة [TextEditingController] الخاص به
/// عند الضغط على "حفظ"، فإنه يُرجع النص المُدخل عبر `Get.back(result: text)`
/// وعند "إلغاء"، يرجع `null`
class AddEditTextDialog extends StatefulWidget {
  final ContentBlock? toEdit;
  const AddEditTextDialog({super.key, this.toEdit});

  @override
  State<AddEditTextDialog> createState() => _AddEditTextDialogState();
}

class _AddEditTextDialogState extends State<AddEditTextDialog> {
  late final TextEditingController textEditController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // تهيئة المتحكم بالنص الموجود (إن كان تعديلاً) أو نص فارغ
    textEditController = TextEditingController(text: widget.toEdit?.data ?? '');
  }

  @override
  void dispose() {
    textEditController.dispose();
    super.dispose();
  }

  /// دالة الحفظ
  void _onSave() {
    // التحقق من صحة الحقل (أنه ليس فارغاً)
    if (_formKey.currentState!.validate()) {
      final text = textEditController.text.trim();
      // إرجاع النص إلى المتحكم (الذي قام بفتح الحوار)
      Get.back(result: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.toEdit != null;
    final theme = Theme.of(context);

    // ألوان الأزرار (يمكن تخصيصها أكثر)
    final primaryBtnColor = theme.colorScheme.onPrimary;
    final secondaryBtnColor = theme.colorScheme.error;

    return CustomDialog(
      title: isEditing ? "تعديل المحتوى" : "إضافة محتوى نصي",
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // لجعل الحوار يأخذ أقل مساحة ممكنة
          children: [
            TextFormField(
              controller: textEditController,
              maxLines: 5,
              minLines: 3,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "اكتب المحتوى هنا...",
                alignLabelWithHint: true,
              ),
              // التحقق من أن الحقل ليس فارغاً
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "لا يمكن ترك المحتوى فارغاً";
                }
                return null;
              },
            ),
            const SizedBox(height: KSizes.spaceBteInputFields * 2),

            // استخدام الأزرار المخصصة
            DualActionButtons(
              // زر "حفظ" (Primary)
              onPrimary: _onSave,
              primaryLabel: "حفظ",
              primaryIcon: Iconsax.save_2,
              primaryColor: primaryBtnColor, // لون النص والأيقونة
              isPrimaryElevated: true, // سيكون زراً مصمتاً (Elevated)
              verticalPadding: 12,
              // زر "إلغاء" (Secondary)
              onSecondary: () => Get.back(), // يغلق الحوار ويرجع null
              secondaryLabel: "إلغاء",
              secondaryIcon: Iconsax.close_circle,
              secondaryColor: secondaryBtnColor, // لون النص والأيقونة
              isSecondaryOutlined: true, // سيكون زراً مفرغاً (Outlined)
            ),
          ],
        ),
      ),
    );
  }
}
