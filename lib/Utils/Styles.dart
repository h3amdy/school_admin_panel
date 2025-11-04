import 'package:ashil_school/AppResources.dart';
import 'package:flutter/cupertino.dart';

TextStyle normalStyle(
    {color = secondaryColor,
    double fontSize = 16,
    fontWeight = FontWeight.normal}) {
  return TextStyle(
      color: color,
      fontFamily: appFont,
      fontSize: fontSize,
      fontWeight: fontWeight);
}
