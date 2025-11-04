import 'package:flutter/material.dart';

goTo(BuildContext context, Widget page) async {
  return await pushWithSlide(context, page);
}

goToAndRemove(BuildContext context, Widget page) async {
  Duration duration = const Duration(milliseconds: 300);
  return await Navigator.of(context).pushAndRemoveUntil(
      _customPageRoute(page, _slideTransition, duration), (route) => false);
}

pushWithSlide(BuildContext context, Widget page,
    {Duration duration = const Duration(milliseconds: 300)}) async {
  return await Navigator.of(context)
      .push(_customPageRoute(page, _slideTransition, duration));
}

pushWithFade(BuildContext context, Widget page,
    {Duration duration = const Duration(milliseconds: 300)}) async {
  return await Navigator.of(context)
      .push(_customPageRoute(page, _fadeTransition, duration));
}

pushWithScale(BuildContext context, Widget page,
    {Duration duration = const Duration(milliseconds: 300)}) async {
  return await Navigator.of(context)
      .push(_customPageRoute(page, _scaleTransition, duration));
}

PageRouteBuilder _customPageRoute(Widget page,
    Widget Function(Animation<double>, Widget) transition, Duration duration) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        transition(animation, child),
    transitionDuration: duration,
  );
}

Widget _slideTransition(Animation<double> animation, Widget child) {
  var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
      .chain(CurveTween(curve: Curves.easeInOut));
  return SlideTransition(position: animation.drive(tween), child: child);
}

Widget _fadeTransition(Animation<double> animation, Widget child) {
  return FadeTransition(opacity: animation, child: child);
}

Widget _scaleTransition(Animation<double> animation, Widget child) {
  return ScaleTransition(scale: animation, child: child);
}
