import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//  ✅  CustomSnackBar:  يظهر  كإشعار  عائم  وأنيق
class CustomSnackBar extends StatefulWidget {
  final String? title;
  final String? message;
  final Color? backgroundColor;
  final Color? textColor;
  final Duration? delay;
  final IconData? icon;

  const CustomSnackBar({
    super.key,
    required this.title,
    this.message,
    this.backgroundColor,
    this.textColor,
    this.delay,
    this.icon,
  });

  static final List<OverlayEntry> _snackBarEntries = [];

  static Future<void> show({
    required String title,
    String? message,
    Color? backgroundColor,
    Color? textColor,
    Duration? delay,
    IconData? icon,
  }) async {
    final completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlayContext = Get.overlayContext;
      if (overlayContext == null) {
        completer.complete();
        return;
      }

      final overlay = Overlay.of(overlayContext);
      if (overlay == null) {
        completer.complete();
        return;
      }

      final GlobalKey<_CustomSnackBarState> snackBarKey =
          GlobalKey<_CustomSnackBarState>();

      final overlayEntry = OverlayEntry(
        builder: (context) => CustomSnackBar(
          key: snackBarKey,
          title: title,
          message: message,
          backgroundColor: backgroundColor,
          textColor: textColor,
          delay: delay,
          icon: icon,
        ),
      );

      CustomSnackBar._snackBarEntries.add(overlayEntry);
      overlay.insert(overlayEntry);

      Future.delayed(delay ?? const Duration(seconds: 3), () async {
        await snackBarKey.currentState?.reverseAnimation();
        CustomSnackBar._snackBarEntries.remove(overlayEntry);
        overlayEntry.remove();
        completer.complete();
      });
    });
    return completer.future;
  }

  @override
  _CustomSnackBarState createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    animationController.forward();
  }

  Future<void> reverseAnimation() async {
    await animationController.reverse();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final index = CustomSnackBar._snackBarEntries
        .indexWhere((entry) => entry.builder(context) == widget);
    final isKeyboardVisible = keyboardSpace > 0;

    return Positioned(
      top: isKeyboardVisible ? 120 + (index * 70) : null,
      bottom: !isKeyboardVisible ? 100 + (index * 70) : null,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: slideAnimation,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.orange,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon ?? Icons.info_outline,
                  color: widget.textColor ?? Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.title != null)
                        Text(
                          widget.title!,
                          style: TextStyle(
                            color: widget.textColor ?? Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (widget.message != null)
                        Text(
                          widget.message!,
                          style: TextStyle(
                              color: widget.textColor ?? Colors.white),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
