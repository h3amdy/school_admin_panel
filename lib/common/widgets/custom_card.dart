import 'package:ashil_school/Utils/theme/decorations/app_decorations.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final bool selected;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const CustomCard({
    super.key,
    required this.child,
    this.selected = false,
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: AppDecorations.cardDecoration(context, selected: selected),
      child: child,
    );
  }
}
