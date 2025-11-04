import 'package:ashil_school/AppResources.dart';
import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:ashil_school/Utils/theme/app_bar_heme.dart';
import 'package:ashil_school/Utils/theme/card_theme.dart';
import 'package:ashil_school/Utils/theme/checkbox_theme.dart';
import 'package:ashil_school/Utils/theme/container_theme.dart';
import 'package:ashil_school/Utils/theme/outlined_button_theme.dart';
import 'package:flutter/material.dart';

class KAppTheme {
  KAppTheme._();

  /// 🔹 ثيم الوضع الفاتح
  static ThemeData buildLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      primary: KColors.primary,
      seedColor: KColors.primary,
      brightness: Brightness.light,
      surface: KColors.light,
      onPrimaryContainer: Colors.blue.shade50,
      background: KColors.light,
      onPrimary: KColors.textPrimary,
    );

    return ThemeData(
      fontFamily: appFont,
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: colorScheme.background,
      extensions: const <ThemeExtension<dynamic>>[
        KContainerTheme.light,
      ],
      cardTheme: buildCardTheme(isDark: false),
      appBarTheme: buildAppBarTheme(isDark: false),
      outlinedButtonTheme: buildOutlinedButtonTheme(isDark: false),
      checkboxTheme: buildCheckboxTheme(isDark: false),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colorScheme.onBackground, fontSize: 14),
        hintStyle:
            TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
      ),
      dividerColor: Colors.grey.shade400,
      shadowColor: Colors.grey.shade400,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.onSurface,
        contentTextStyle: TextStyle(color: colorScheme.surface, fontSize: 14),
        behavior: SnackBarBehavior.floating,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant.withOpacity(0.6),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground),
        headlineMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onBackground),
        headlineSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.onBackground),
        bodyLarge: TextStyle(fontSize: 16, color: colorScheme.onBackground),
        bodyMedium: TextStyle(fontSize: 14, color: colorScheme.onBackground),
        bodySmall: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground),
        titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onBackground),
        titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.onBackground),
      ),
    );
  }

  /// 🔹 ثيم الوضع الداكن
  static ThemeData buildDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      primary: KColors.primary,
      seedColor: KColors.primary,
      brightness: Brightness.dark,
      surface: KColors.darkContainer,
      onPrimaryContainer: KColors.darkContainer,
      background: KColors.dark,
      onBackground: KColors.textWhite,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colorScheme.background,
      extensions: const <ThemeExtension<dynamic>>[
        KContainerTheme.dark,
      ],
      cardTheme: buildCardTheme(isDark: true),
      appBarTheme: buildAppBarTheme(isDark: true),
      outlinedButtonTheme: buildOutlinedButtonTheme(isDark: true),
      checkboxTheme: buildCheckboxTheme(isDark: true),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KColors.dark.withOpacity(0.5),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
        hintStyle:
            TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.onSurface,
        contentTextStyle: TextStyle(color: colorScheme.surface, fontSize: 14),
        behavior: SnackBarBehavior.floating,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant.withOpacity(0.6),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
      ),
      dividerColor: KColors.darkGrey,
      shadowColor: KColors.darkGrey,
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground),
        headlineMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onBackground),
        headlineSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.onBackground),
        bodyLarge: TextStyle(fontSize: 16, color: colorScheme.onBackground),
        bodyMedium: TextStyle(fontSize: 14, color: colorScheme.onBackground),
        bodySmall: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground),
        titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onBackground),
        titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.onBackground),
      ),
    );
  }
}
