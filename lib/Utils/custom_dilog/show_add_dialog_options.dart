import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// يعرض مربع حوار منبثق متحرك مع خيارين.
///
/// المعاملات:
/// - `context`: سياق البناء.
/// - `isShowingAdd`: متغير حالة للتحكم في عرض وإخفاء الحوار.
/// - `firstIcon`: الأيقونة الخاصة بالخيار الأول.
/// - `firstLabel`: النص الظاهر أسفل الأيقونة الأولى.
/// - `firstOnTap`: الدالة التي سيتم تنفيذها عند النقر على الخيار الأول.
/// - `secondIcon`: الأيقونة الخاصة بالخيار الثاني.
/// - `secondLabel`: النص الظاهر أسفل الأيقونة الثانية.
/// - `secondOnTap`: الدالة التي سيتم تنفيذها عند النقر على الخيار الثاني.
void showTwoOptionDialog({
  required BuildContext context,
  required RxBool isShowingAdd,
  required IconData firstIcon,
  required String firstLabel,
  required VoidCallback firstOnTap,
  required IconData secondIcon,
  required String secondLabel,
  required VoidCallback secondOnTap,
}) {
  if (isShowingAdd.value) {
    // إغلاق الحوار إذا كان ظاهرًا
    Get.back();
    isShowingAdd.value = false;
  } else {
    // عرض الحوار
    isShowingAdd.value = true;
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // يسمح بالنقر خارج النافذة لإغلاقها
      barrierLabel: '',
      barrierColor: Colors.transparent, // جعل الخلفية شفافة للسماح بالتفاعل
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        // متغيرات التحكم في ظهور الأيقونات
        final List<ValueNotifier<bool>> visibilityNotifiers = [
          ValueNotifier(false),
          ValueNotifier(false),
        ];

        // تفعيل الأيقونات بشكل متسلسل
        Future.delayed(const Duration(milliseconds: 0),
            () => visibilityNotifiers[0].value = true);
        Future.delayed(const Duration(milliseconds: 150),
            () => visibilityNotifiers[1].value = true);
        final primaryColor = Theme.of(context).primaryColor;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 70,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // الخيار الأول
                ValueListenableBuilder<bool>(
                  valueListenable: visibilityNotifiers[0],
                  builder: (context, visible, _) {
                    return AnimatedAlign(
                      alignment: visible
                          ? const Alignment(-0.25, 1)
                          : Alignment.bottomCenter,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          isShowingAdd.value = false;
                          firstOnTap();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  primaryColor.withValues(alpha: 0.3),
                              child: Icon(firstIcon,
                                  color: primaryColor, size: 30),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              firstLabel,
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // الخيار الثاني
                ValueListenableBuilder<bool>(
                  valueListenable: visibilityNotifiers[1],
                  builder: (context, visible, _) {
                    return AnimatedAlign(
                      alignment: visible
                          ? const Alignment(0.25, 1)
                          : Alignment.bottomCenter,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          isShowingAdd.value = false;
                          secondOnTap();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  primaryColor.withValues(alpha: 0.3),
                              child: Icon(secondIcon,
                                  color: primaryColor, size: 30),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              secondLabel,
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // عندما يتم إغلاق الحوار، أعد ضبط المتغير
      isShowingAdd.value = false;
    });
  }
}
