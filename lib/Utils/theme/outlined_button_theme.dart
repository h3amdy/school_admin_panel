// lib/Utils/theme/outlined_button_theme.dart
import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:flutter/material.dart';

OutlinedButtonThemeData buildOutlinedButtonTheme({required bool isDark}) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: isDark ? KColors.textWhite : KColors.primary,
      side: BorderSide(
        color: isDark ? KColors.primary : KColors.primary.withOpacity(0.5),
        width: 1.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}