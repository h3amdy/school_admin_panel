import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:flutter/material.dart';

AppBarTheme buildAppBarTheme({required bool isDark}) {
  return AppBarTheme(
    backgroundColor: isDark ? KColors.darkContainer : KColors.primary,
    foregroundColor: KColors.textWhite,
    elevation: isDark ? 0 : 2,
    centerTitle: true,
    titleTextStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: KColors.textWhite,
      letterSpacing: 0.5,
    ),
    iconTheme: const IconThemeData(color: KColors.textWhite, size: 22),
    actionsIconTheme: const IconThemeData(color: KColors.textWhite, size: 22),
    toolbarHeight: 56,
    shadowColor: isDark ? Colors.transparent : KColors.primary.withOpacity(0.3),
    surfaceTintColor: Colors.transparent,
  );
}
