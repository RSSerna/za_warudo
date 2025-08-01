import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:za_warudo/pref_keys.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.themeMode, mode.name);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString(PrefKeys.themeMode);
    if (mode != null) {
      _themeMode = ThemeMode.values
          .firstWhere((e) => e.name == mode, orElse: () => ThemeMode.system);
      notifyListeners();
    }
  }
}
