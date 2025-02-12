import 'package:flutter/material.dart';

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

  set themeData(ThemeData themeData) {
    _themeData = themeData;
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
