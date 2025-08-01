import 'package:flutter/material.dart';

class AlarmProvider extends ChangeNotifier {
  bool sound = false;
  bool vibration = false;
  bool colorFlash = false;
  bool flashlight = false;
  bool manualStop = false;

  TimeOfDay? alarmTime;
  bool isAlarmSet = false;

  void setOption(String key, bool value) {
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
  }

  void setAlarmTime(TimeOfDay? t) {
    alarmTime = t;
    notifyListeners();
  }

  void setAlarmSet(bool set) {
    isAlarmSet = set;
    notifyListeners();
  }
}
