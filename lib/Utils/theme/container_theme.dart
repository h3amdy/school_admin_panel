import 'package:flutter/material.dart';
import '../constants/colors.dart';

@immutable
class KContainerTheme extends ThemeExtension<KContainerTheme> {
  final BoxDecoration container;

  const KContainerTheme({required this.container});

  // نسخة الـ Light
  static const light = KContainerTheme(
    container: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      border: Border.fromBorderSide(
        BorderSide(color: KColors.primary, width: 1.2),
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0x22000000),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
  );

  // نسخة الـ Dark
  static const dark = KContainerTheme(
    container: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      border: Border.fromBorderSide(
        BorderSide(color: KColors.grey, width: 1.2),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
  );

  @override
  KContainerTheme copyWith({BoxDecoration? container}) {
    return KContainerTheme(container: container ?? this.container);
  }

  @override
  KContainerTheme lerp(ThemeExtension<KContainerTheme>? other, double t) {
    if (other is! KContainerTheme) return this;
    return KContainerTheme(
      container: BoxDecoration.lerp(container, other.container, t)!,
    );
  }
}
