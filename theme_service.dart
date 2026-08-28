import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeService extends ChangeNotifier {
  final Box _settingsBox = Hive.box('settings_box');

  ThemeMode get themeMode {
    final isDark = _settingsBox.get('dark_mode', defaultValue: false) as bool;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme() {
    final current = _settingsBox.get('dark_mode', defaultValue: false) as bool;
    _settingsBox.put('dark_mode', !current);
    notifyListeners();
  }
}
