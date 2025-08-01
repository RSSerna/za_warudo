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
    switch (key) {
      case 'sound':
        sound = value;
        break;
      case 'vibration':
        vibration = value;
        break;
      case 'colorFlash':
        colorFlash = value;
        break;
      case 'flashlight':
        flashlight = value;
        break;
      case 'manualStop':
        manualStop = value;
        break;
    }
    notifyListeners();
    await _savePrefs();
  }

  Future<void> setAlarmTime(TimeOfDay? t) async {
    alarmTime = t;
    notifyListeners();
    await _savePrefs();
  }

  void setAlarmSet(bool set) {
    isAlarmSet = set;
    notifyListeners();
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(PrefKeys.alarmSound, sound);
    prefs.setBool(PrefKeys.alarmVibration, vibration);
    prefs.setBool(PrefKeys.alarmColorFlash, colorFlash);
    prefs.setBool(PrefKeys.alarmFlashlight, flashlight);
    prefs.setBool(PrefKeys.alarmManualStop, manualStop);
    if (alarmTime != null) {
      prefs.setInt(PrefKeys.alarmHour, alarmTime!.hour);
      prefs.setInt(PrefKeys.alarmMinute, alarmTime!.minute);
    }
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
