import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:za_warudo/pref_keys.dart';

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
    final prefs = await SharedPreferences.getInstance();
    switch (key) {
      case 'sound':
        sound = value;
        await prefs.setBool(PrefKeys.timerSound, value);
        break;
      case 'vibration':
        vibration = value;
        await prefs.setBool(PrefKeys.timerVibration, value);
        break;
      case 'colorFlash':
        colorFlash = value;
        await prefs.setBool(PrefKeys.timerColorFlash, value);
        break;
      case 'flashlight':
        flashlight = value;
        await prefs.setBool(PrefKeys.timerFlashlight, value);
        break;
      case 'manualStop':
        manualStop = value;
        await prefs.setBool(PrefKeys.timerManualStop, value);
        break;
    }
    notifyListeners();
  }

  Future<void> setTimerDuration(Duration d) async {
    timerDuration = d;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(PrefKeys.timerDuration, timerDuration.inSeconds);
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

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    sound = prefs.getBool(PrefKeys.timerSound) ?? false;
    vibration = prefs.getBool(PrefKeys.timerVibration) ?? false;
    colorFlash = prefs.getBool(PrefKeys.timerColorFlash) ?? false;
    flashlight = prefs.getBool(PrefKeys.timerFlashlight) ?? false;
    manualStop = prefs.getBool(PrefKeys.timerManualStop) ?? false;
    final seconds = prefs.getInt(PrefKeys.timerDuration);
    if (seconds != null) {
      timerDuration = Duration(seconds: seconds);
    }
    notifyListeners();
  }
}
