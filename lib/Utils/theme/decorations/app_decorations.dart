import 'package:flutter/material.dart';

class AppDecorations {
  /// الكارد الأساسي
  static BoxDecoration cardDecoration(BuildContext context, {bool selected = false}) {
    final theme = Theme.of(context);
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 4),
          color: selected
              ? theme.colorScheme.primary.withOpacity(0.3)
              : theme.shadowColor,
          
        ),
      ],
      color: selected
          ? theme.colorScheme.primary.withOpacity(0.1)
          : theme.cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: selected ? theme.colorScheme.primary : theme.dividerColor,
      ),
    );
  }

  /// كارد ثانوي (مثال ثاني)
  static BoxDecoration secondaryCard(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.secondary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: theme.colorScheme.secondary),
    );
  }

  /// كارد بخلفية Gradient
  static BoxDecoration gradientCard() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
