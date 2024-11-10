import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static late final SharedPreferences themeManager;
  static const String themeKey = "THEME_KEY";

  static initThemePref() async {
    themeManager = await SharedPreferences.getInstance();
  }

  static storeTheme(bool isThemeLight) async {
    await themeManager.setBool(themeKey, isThemeLight);
  }

  static bool getTheme() {
    return themeManager.getBool(themeKey) ?? false;
  }
}
