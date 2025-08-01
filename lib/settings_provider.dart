import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:za_warudo/pref_keys.dart';

class SettingsProvider extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  SettingsProvider() {
    _loadLocale();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.locale, locale.languageCode);
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(PrefKeys.locale);
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }
}
