import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:za_warudo/pref_keys.dart';

class AlarmProvider extends ChangeNotifier {
  bool sound = false;
  bool vibration = false;
  bool colorFlash = false;
  bool flashlight = false;
  bool manualStop = false;

  TimeOfDay? alarmTime;
  bool isAlarmSet = false;

  AlarmProvider() {
    _loadPrefs();
  }

  Future<void> setOption(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (key) {
      case 'sound':
        sound = value;
        await prefs.setBool(PrefKeys.alarmSound, value);
        break;
      case 'vibration':
        vibration = value;
        await prefs.setBool(PrefKeys.alarmVibration, value);
        break;
      case 'colorFlash':
        colorFlash = value;
        await prefs.setBool(PrefKeys.alarmColorFlash, value);
        break;
      case 'flashlight':
        flashlight = value;
        await prefs.setBool(PrefKeys.alarmFlashlight, value);
        break;
      case 'manualStop':
        manualStop = value;
        await prefs.setBool(PrefKeys.alarmManualStop, value);
        break;
    }
    notifyListeners();
  }

  Future<void> setAlarmTime(TimeOfDay? t) async {
    alarmTime = t;
    notifyListeners();
    if (alarmTime != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(PrefKeys.alarmHour, alarmTime!.hour);
      await prefs.setInt(PrefKeys.alarmMinute, alarmTime!.minute);
    }
  }

  void setAlarmSet(bool set) {
    isAlarmSet = set;
    notifyListeners();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    sound = prefs.getBool(PrefKeys.alarmSound) ?? false;
    vibration = prefs.getBool(PrefKeys.alarmVibration) ?? false;
    colorFlash = prefs.getBool(PrefKeys.alarmColorFlash) ?? false;
    flashlight = prefs.getBool(PrefKeys.alarmFlashlight) ?? false;
    manualStop = prefs.getBool(PrefKeys.alarmManualStop) ?? false;
    final hour = prefs.getInt(PrefKeys.alarmHour);
    final minute = prefs.getInt(PrefKeys.alarmMinute);
    if (hour != null && minute != null) {
      alarmTime = TimeOfDay(hour: hour, minute: minute);
    }
    notifyListeners();
  }
}
