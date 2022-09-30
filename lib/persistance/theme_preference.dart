import 'package:flutter/material.dart';
import '../main.dart';

const themeStatus = 'THEME_STATUS';

class ThemePreference {
  static final ThemePreference _singleton = ThemePreference._internal();

  ThemePreference._internal();

  factory ThemePreference() {
    return _singleton;
  }

  setTheme(ThemeMode themeMode) async {
    prefs.setString(themeStatus, themeMode.name);
  }

  Future<String?> getTheme() async {
    return prefs.getString(themeStatus);
  }
}
