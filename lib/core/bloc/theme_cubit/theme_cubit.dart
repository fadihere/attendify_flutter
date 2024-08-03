import 'package:attendify_lite/core/services/keys/local.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../config/theme/app_theme.dart';
import '../../services/database/shared_pref.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.light)) {
    final themeMode = SharedPref.getBool(LocalKeys.isDarkMode) ?? false
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(ThemeState(themeMode: themeMode));
  }

  void updateAppTheme() {
    final Brightness currentBrightness = AppTheme.currentSystemBrightness;
    currentBrightness == Brightness.light
        ? setTheme(ThemeMode.dark)
        : setTheme(ThemeMode.light);
  }

  void setTheme(ThemeMode themeMode) {
    AppTheme.setStatusBarAndNavigationBarColors(themeMode);
    emit(ThemeState(themeMode: themeMode));
    SharedPref.setBool(LocalKeys.isDarkMode, themeMode == ThemeMode.dark);
  }
}
