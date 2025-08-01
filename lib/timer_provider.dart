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
    prefs.setBool(PrefKeys.timerSound, sound);
    prefs.setBool(PrefKeys.timerVibration, vibration);
    prefs.setBool(PrefKeys.timerColorFlash, colorFlash);
    prefs.setBool(PrefKeys.timerFlashlight, flashlight);
    prefs.setBool(PrefKeys.timerManualStop, manualStop);
    prefs.setInt(PrefKeys.timerDuration, timerDuration.inSeconds);
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
