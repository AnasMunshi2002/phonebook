import 'package:flutter/material.dart';

import '../../services/shared_pref/theme_manager/theme_pref_manager.dart';
import 'dark.dart';
import 'light.dart';

class CtTheme extends ChangeNotifier {
  var themeManager = ThemeManager.getTheme();

  final ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme.light(
    secondaryFixed: LightColors.secondaryFixed,
    brightness: Brightness.light,
    primary: LightColors.primary,
    secondary: LightColors.secondary,
    onSecondary: LightColors.onSecondary,
    tertiary: LightColors.tertiary,
  ));

  late ThemeData currentTheme = themeManager ? darkTheme : lightTheme;

  final ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme.dark(
    secondaryFixed: DarkColors.secondaryFixed,
    brightness: Brightness.dark,
    primary: DarkColors.primary,
    secondary: DarkColors.secondary,
    onSecondary: DarkColors.onSecondary,
    tertiary: DarkColors.tertiary,
  ));

  toggleTheme() {
    if (currentTheme == lightTheme) {
      currentTheme = darkTheme;
    } else {
      currentTheme = lightTheme;
    }
    themeManager = !themeManager;
    notifyListeners();
  }
}
