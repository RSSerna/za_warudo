import 'package:flutter/material.dart';
// Uncomment and add these packages to pubspec.yaml when ready:
// import 'package:audioplayers/audioplayers.dart';
// import 'package:vibration/vibration.dart';
// import 'package:torch_light/torch_light.dart';

class TriggerService {
  static Future<void> playSound() async {
    // TODO: Implement using audioplayers
    // final player = AudioPlayer();
    // await player.play(AssetSource('sounds/alarm.mp3'));
  }

  static Future<void> vibrateDevice() async {
    // TODO: Implement using vibration
    // if (await Vibration.hasVibrator() ?? false) {
    //   Vibration.vibrate(duration: 1000);
    // }
  }

  static Future<void> flashLight() async {
    // TODO: Implement using torch_light
    // await TorchLight.enableTorch();
    // await Future.delayed(Duration(seconds: 2));
    // await TorchLight.disableTorch();
  }

  static Future<void> showColorFlash(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.red.withValues(alpha: 0.9),
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
