import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../constants/app_colors.dart';
import '../../gen/fonts.gen.dart';

class AppTheme {
  const AppTheme._();

  static final lightTheme = ThemeData(
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: LightColors.primary),
    scaffoldBackgroundColor: LightColors.background,
    brightness: Brightness.light,
    fontFamily: FontFamily.hellix,
    actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) => Icon(
              Icons.arrow_back_ios_rounded,
              color: context.color.font,
            )),
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: DarkColors.icon),
      centerTitle: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: LightColors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color: LightColors.icon,
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(),
      bodyLarge: TextStyle(),
    ).apply(
      bodyColor: LightColors.font,
      displayColor: LightColors.font,
      fontFamily: FontFamily.hellix,
    ),
    iconTheme: const IconThemeData(color: LightColors.icon),
    colorScheme: LightColors.primaryScheme,
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: DarkColors.background,
    brightness: Brightness.dark,
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) => Icon(
        Icons.arrow_back_ios_rounded,
        color: context.color.font,
      ),
    ),
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: DarkColors.icon),
      centerTitle: true,
      backgroundColor: DarkColors.background,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: DarkColors.font,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: DarkColors.icon),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
    ).apply(
      bodyColor: DarkColors.font,
      displayColor: DarkColors.font,
      fontFamily: FontFamily.hellix,
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: DarkColors.primary),
    iconTheme: const IconThemeData(color: DarkColors.icon),
    primaryColor: DarkColors.primary,
    colorScheme: DarkColors.primaryScheme,
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: FontFamily.hellix,
  );

  static Brightness get currentSystemBrightness =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  static void setStatusBarAndNavigationBarColors(ThemeMode themeMode) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarIconBrightness:
    //         themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
    //     systemNavigationBarIconBrightness:
    //         themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
    //     systemNavigationBarColor:
    //         themeMode == ThemeMode.light ? Colors.white : Colors.grey,
    //     systemNavigationBarDividerColor: Colors.transparent,
    //   ),
    // );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness:
            themeMode == ThemeMode.light ? Brightness.light : Brightness.dark,
      ),
    );
  }
}

extension ThemeExtras on ThemeData {
  bool get _isLight => brightness == Brightness.light;

  Color get primary => _isLight ? LightColors.primary : DarkColors.primary;
  Color get font => _isLight ? LightColors.font : DarkColors.font;
  Color get hint => _isLight ? LightColors.hint : DarkColors.hint;
  Color get hintDark => _isLight ? LightColors.hintDark : DarkColors.hintDark;

  Color get outline => _isLight ? LightColors.outline : DarkColors.outline;
  Color get icon => _isLight ? LightColors.icon : DarkColors.icon;
  Color get warning => _isLight ? LightColors.warning : DarkColors.warning;
  Color get whiteBlack => _isLight ? LightColors.white : DarkColors.dropShadow;
  Color get late => _isLight ? LightColors.late : DarkColors.late;
  Color get wfh => _isLight ? LightColors.wfh : DarkColors.wfh;

  Color get container =>
      _isLight ? LightColors.container : DarkColors.container;

  Color get dropShadow =>
      _isLight ? LightColors.dropShadow : DarkColors.dropShadow;

  Color get divider => _isLight ? LightColors.divider : DarkColors.divider;

  Color get present =>
      _isLight ? LightColors.present : DarkColors.approvedButtonColor;

  Color get white => _isLight ? LightColors.white : DarkColors.white;
  Color get red => _isLight ? LightColors.red : DarkColors.red;
}

extension ThemeContext on BuildContext {
  ThemeData get color => Theme.of(this);
}
