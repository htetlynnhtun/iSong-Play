import 'package:flutter/material.dart';
import '../persistance/theme_preference.dart';

class ThemeBloc extends ChangeNotifier {
  ThemeMode? themeMode;

  ///preference
  final ThemePreference _preference = ThemePreference();

  ThemeBloc() {
    _preference.getTheme().then((value) {
      if (value != null) {
        themeMode = _updateThemeMode(value);
      } else {
        themeMode = ThemeMode.system;
        _preference.setTheme(themeMode!);
      }
      notifyListeners();
    });
  }

  void onTapRadio(ThemeMode? themeMode) {
    this.themeMode = themeMode!;
    themeMode = _updateThemeMode(themeMode.name);
    _preference.setTheme(themeMode!);
    notifyListeners();
  }

  bool isAutomatic() {
    return themeMode == ThemeMode.system;
  }

  ThemeMode? _updateThemeMode(String themeName) {
    switch (themeName) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'system':
        themeMode = ThemeMode.system;
    }
    return themeMode;
  }
}
