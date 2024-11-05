import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxController {
  final _box = GetStorage(); // Initialize GetStorage for saving theme preferences.
  final _key = 'isDarkMode';

  RxBool isDarkMode = false.obs;

  ThemeService() {
    isDarkMode.value = _loadThemeFromBox();
  }

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  // Switch between light and dark themes.
  void switchTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToBox(isDarkMode.value);
  }
}

class MyAppThemes {
  // light theme data
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
          backgroundColor: Colors.grey[800],
          textStyle: const TextStyle(fontSize: 16, color: Colors.white),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    ),
  );
  // dark theme data
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          textStyle: const TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          foregroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    ),
  );
}
