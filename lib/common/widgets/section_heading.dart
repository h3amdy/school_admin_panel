import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class KSectionHeading extends StatelessWidget {
  const KSectionHeading(
      {super.key,
      required this.title,
      this.textColor,
      this.onPressed,
      this.showArrow = true,
      this.isch = false});

  final String title;
  final Color? textColor;
  final Function()? onPressed;

  final bool showArrow;
  final bool isch;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.theme.primaryColor;
     final secandryColor = context.theme.colorScheme.secondary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (showArrow)
          Icon(
            Icons.arrow_right,
            color: primaryColor,
            size: 40,
          ),
        Text(
          title,
          style: TextStyle(
              color:primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        isch
            ? Text(
                " (اختياري)",
                style: TextStyle(
                    color: secandryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
