import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget body;

  const CustomDialog({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    // تم إزالة TweenAnimationBuilder من هنا لكي تظهر النافذة بشكل فوري
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 15, // هنا تقلل الهامش من الجوانب
        vertical: 1, // هنا تقلل الهامش من الأعلى والأسفل
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KSizes.borderRadiusSmLg),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    final theme = Theme.of(context);
    final containerColor = theme.colorScheme.onPrimaryContainer;
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: theme.scaffoldBackgroundColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(KSizes.borderRadiusSmLg)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Header Section with rounded top corners
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Close Button
              Container(
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(KSizes.borderRadiusSmLg - 5),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 36,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              // ✅ هنا يتم تطبيق الحركة على العنوان
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                builder: (context, scale, child) {
                  return Expanded(
                    child: Transform.scale(
                      scale: scale,
                      // ✅ إضافة تأثير الشفافية ليظهر العنوان تدريجياً
                      child: Opacity(
                        opacity: scale,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(KSizes.borderRadiusSmLg - 5)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    title,
                    style: theme.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),

          // Transparent Separator (Optional)
          const SizedBox(height: 12),

          // Body Section with rounded bottom corners
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(KSizes.borderRadiusSmLg - 5),
                    bottomRight: Radius.circular(KSizes.borderRadiusSmLg - 5)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 6),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
