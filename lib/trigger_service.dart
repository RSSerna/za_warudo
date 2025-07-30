import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:vibration/vibration.dart';

class TriggerService {
  static Future<void> playSound() async {
    try {
      final player = AudioPlayer();
      // Make sure you have a sound file at assets/sounds/alarm.mp3 and declared in pubspec.yaml
      await player.play(AssetSource('sounds/alarm.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  static Future<void> vibrateDevice() async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 1000);
      }
    } catch (e) {
      debugPrint('Error vibrating device: $e');
    }
  }

  static Future<void> flashLight() async {
    try {
      await TorchLight.enableTorch();
      await Future.delayed(const Duration(seconds: 2));
      await TorchLight.disableTorch();
    } catch (e) {
      debugPrint('Error using flashlight: $e');
    }
  }

  static Future<void> showColorFlash(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.red.withOpacity(0.9),
          child: const Center(
            child: Text(
              'FLASH!',
              style: TextStyle(fontSize: 48, color: Colors.white),
            ),
          ),
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  static Future<void> triggerAll({
    required BuildContext context,
    required bool sound,
    required bool vibration,
    required bool colorFlash,
    required bool flashlight,
  }) async {
    if (sound) await playSound();
    if (vibration) await vibrateDevice();
    if (colorFlash) await showColorFlash(context);
    if (flashlight) await flashLight();
  }
}
