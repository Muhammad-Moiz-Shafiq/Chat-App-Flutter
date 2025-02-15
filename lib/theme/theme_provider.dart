import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade100,
    tertiary: Colors.grey.shade300,
    inversePrimary: Colors.grey.shade700,
  ),
);

ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme.dark(
  surface: const Color.fromARGB(255, 20, 20, 20),
  primary: const Color.fromARGB(255, 122, 122, 122),
  secondary: const Color.fromARGB(255, 30, 30, 30),
  tertiary: const Color.fromARGB(255, 47, 47, 47),
  inversePrimary: Colors.grey.shade200,
));

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;
  final String _themePreferenceKey = 'theme_preference';

  ThemeProvider() {
    _loadThemePreference();
  }

  // Load saved theme preference
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themePreferenceKey) ?? false;
    _themeData = isDark ? darkMode : lightMode;
    notifyListeners();
  }

  // Save theme preference
  Future<void> _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePreferenceKey, isDark);
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveThemePreference(_themeData == darkMode);
    notifyListeners();
  }

  ThemeData get themeData => _themeData;

  bool isDarkMode() {
    return _themeData == darkMode;
  }

  void toggleTheme() {
    if (_themeData == darkMode) {
      themeData = lightMode;
    } else {
      themeData = darkMode;
    }
  }
}
