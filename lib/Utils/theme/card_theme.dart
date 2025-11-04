import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:flutter/material.dart';

CardThemeData buildCardTheme({required bool isDark}) {
  return CardThemeData(
    color: isDark ? KColors.darkContainer : KColors.white,
    elevation: isDark ? 2 : 3,
    shadowColor: KColors.primary.withOpacity(0.25),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: isDark
            ? KColors.white.withOpacity(0.05)
            : KColors.primary.withOpacity(0.1),
        width: 1,
      ),
    ),
  );
}
