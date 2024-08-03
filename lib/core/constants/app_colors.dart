import 'package:flutter/material.dart';

class LightColors {
  static ColorScheme primaryScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
    surface: Colors.transparent,
    surfaceTint: Colors.transparent,
  );
  static const Color primary = Color(0xFF639EFF);
  static const Color transparent = Colors.transparent;
  static const Color icon = Color(0xFF444444);
  static const Color font = Color(0xFF222222);
  static const Color hint = Color(0xFF999999);
  static const Color hintDark = Color(0xFF666666);

  static const Color black = Colors.black;

  static const Color white = Colors.white;
  static const Color background = Colors.white;
  static const Color grey = Color(0xFF999999);
  static const Color darkgrey = Color(0xFF222222);
  static const Color outline = Color(0xFFDDDDDD);
  static const Color disable = Color(0xFFEEEEEE);
  static const Color disableFont = Color(0xFF666666);
  static const Color warning = Color(0xFFEA4335);
  static const Color dropShadow = Color(0xFF212121);
  static const Color present = Color(0xFF35D388);
  static const Color container = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFDDDDDD);
  static const Color late = Color(0xFFFFC545);
  static const Color wfh = Color(0xFF7E857E);
  static const Color red = Color(0xFFFF355A);
}

class DarkColors {
  static ColorScheme primaryScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
    surface: Colors.transparent,
    surfaceTint: Colors.transparent,
  );
  static const Color primary = Color(0xFF639EFF);
  static const Color transparent = Colors.transparent;
  static const Color icon = Color(0xFFFFFFFF);
  static const Color font = Colors.white;
  static const Color hint = Color(0xFF666666);
  static const Color hintDark = Color(0xFF666666);

  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color background = Color(0xFF0D0D0D);
  static const Color grey = Color(0xFF999999);
  static const Color darkgrey = Color(0xFF222222);
  static const Color outline = Color(0xFF35383F);
  static const Color disable = Color(0xFFEEEEEE);
  static const Color disableFont = Color(0xFF666666);
  static const Color warning = Color(0xFFEA4335);
  static const Color dropShadow = Color(0xFF212121);
  static const Color approvedButtonColor = Color(0xFF35D388);
  static const Color container = Color(0xFF202020);
  static const Color divider = Color(0xFF35383F);
  static const Color late = Color(0xFFFFC545);
  static const Color wfh = Color(0xFF7E857E);
  static const Color red = Color(0xFFFF355A);
}
