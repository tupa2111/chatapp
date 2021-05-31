import 'package:flutter/material.dart';

class CustomTheme {
  static Color colorAccent = Color(0xff007EF4);
  static Color textColor = Color(0xff071930);
}

class Styles {
  static TextStyle styles1({
    Color color,
    FontWeight fontWeight = FontWeight.normal,
    double fontSize,
    TextDecoration decoration,
    FontStyle fontStyle,
  }) => TextStyle(
      fontSize: fontSize ?? 22,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      decoration: decoration ?? TextDecoration.none,
      fontStyle: fontStyle);
}
