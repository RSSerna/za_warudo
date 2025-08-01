import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerProvider extends ChangeNotifier {
  bool sound = false;
  bool vibration = false;
  bool colorFlash = false;
  bool flashlight = false;
  bool manualStop = false;

  Duration timerDuration = const Duration(seconds: 10);
  bool isRunning = false;
  bool isPaused = false;
  Duration remaining = Duration.zero;

  TimerProvider() {
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

  Future<void> setTimerDuration(Duration d) async {
    timerDuration = d;
    notifyListeners();
    await _savePrefs();
  }

  void setTimerRunning(bool running) {
    isRunning = running;
    notifyListeners();
  }

  void setTimerPaused(bool paused) {
    isPaused = paused;
    notifyListeners();
  }

  void setTimerRemaining(Duration d) {
    remaining = d;
    notifyListeners();
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('timer_sound', sound);
    prefs.setBool('timer_vibration', vibration);
    prefs.setBool('timer_colorFlash', colorFlash);
    prefs.setBool('timer_flashlight', flashlight);
    prefs.setBool('timer_manualStop', manualStop);
    prefs.setInt('timer_duration', timerDuration.inSeconds);
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    sound = prefs.getBool('timer_sound') ?? false;
    vibration = prefs.getBool('timer_vibration') ?? false;
    colorFlash = prefs.getBool('timer_colorFlash') ?? false;
    flashlight = prefs.getBool('timer_flashlight') ?? false;
    manualStop = prefs.getBool('timer_manualStop') ?? false;
    final seconds = prefs.getInt('timer_duration');
    if (seconds != null) {
      timerDuration = Duration(seconds: seconds);
    }
    notifyListeners();
  }
}
