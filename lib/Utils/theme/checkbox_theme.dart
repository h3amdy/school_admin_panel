import 'package:flutter/material.dart';
import 'package:ashil_school/Utils/constants/colors.dart';

/// 🔹 ثيم Checkbox
CheckboxThemeData buildCheckboxTheme({required bool isDark}) {
  return CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6), // زوايا ناعمة
    ),
    checkColor: WidgetStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return KColors.textWhite; // لون علامة الصح
        }
        return isDark ? KColors.textWhite70 : KColors.textPrimary;
      },
    ),
    fillColor: WidgetStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return KColors.primary; // اللون عند التحديد
        }
        return isDark ? KColors.grey : KColors.grey.withOpacity(0.4);
      },
    ),
    overlayColor: WidgetStateProperty.all(
      KColors.primary.withOpacity(0.1), // تأثير الضغط
    ),
    side: BorderSide(
      color: isDark ? KColors.textWhite70 : KColors.textSecondary,
      width: 1.5,
    ),
  );
}
