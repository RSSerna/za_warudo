import 'package:flutter/material.dart';

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

  void setTimerDuration(Duration d) {
    timerDuration = d;
    notifyListeners();
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
}
