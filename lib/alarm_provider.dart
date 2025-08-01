import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    prefs.setBool('alarm_sound', sound);
    prefs.setBool('alarm_vibration', vibration);
    prefs.setBool('alarm_colorFlash', colorFlash);
    prefs.setBool('alarm_flashlight', flashlight);
    prefs.setBool('alarm_manualStop', manualStop);
    if (alarmTime != null) {
      prefs.setInt('alarm_hour', alarmTime!.hour);
      prefs.setInt('alarm_minute', alarmTime!.minute);
    }
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    sound = prefs.getBool('alarm_sound') ?? false;
    vibration = prefs.getBool('alarm_vibration') ?? false;
    colorFlash = prefs.getBool('alarm_colorFlash') ?? false;
    flashlight = prefs.getBool('alarm_flashlight') ?? false;
    manualStop = prefs.getBool('alarm_manualStop') ?? false;
    final hour = prefs.getInt('alarm_hour');
    final minute = prefs.getInt('alarm_minute');
    if (hour != null && minute != null) {
      alarmTime = TimeOfDay(hour: hour, minute: minute);
    }
    notifyListeners();
  }
}
