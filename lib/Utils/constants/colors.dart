import 'package:flutter/material.dart';

class KColors {
  KColors._();

  // ألوان التطبيق الأساسية
  static const Color primary = Color(0xFF1976D2); // الأزرق الرئيسي
  static const Color secondary = Color(0xFF1565C0); // أزرق أغمق قليلًا
  static const Color accent = Color(0xFFBBDEFB); // أزرق فاتح كلون ثانوي

  // ألوان التدرج
  static const Gradient linerGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [Color(0xFF1E88E5), Color(0xFF42A5F5), Color(0xFF64B5F6)],
  );

  // ألوان النص
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Colors.white70; // 🆕
  static const Color textWhite60 = Colors.white60; // 🆕

  // ألوان الخلفية
  static const Color light = Color(0xFFF5F5F5);
  static const Color dark = Color(0xFF121212);
  static const Color primaryBackground = Color(0xFFE3F2FD);

  // ألوان الحاويات
  static const Color lightContainer = Color(0xFFE3F2FD);
  static Color darkContainer = const Color(0xFF181E2E);

  // ألوان الأزرار
  static const Color buttonPrimary = Color(0xFF1976D2);
  static const Color buttonSecondary = Color(0xFFE0E0E0);
  static const Color buttonDisabled = Color(0xFFBDBDBD);

  // ألوان الحدود
  static const Color borderPrimary = Color(0xFF90CAF9);
  static const Color borderSecondary = Color(0xFFE0E0E0);

  // ألوان التحقق والأخطاء
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);
  static const Color orange = Colors.orange;

  // الألوان المحايدة
  static const Color black = Color(0xFF212121);
  static const Color darkerGrey = Color(0xFF424242);
  static const Color darkGrey = Color(0xFF616161);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color softGrey = Color(0xFFEEEEEE);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);
}
