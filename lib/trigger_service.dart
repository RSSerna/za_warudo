import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:vibration/vibration.dart';

class TriggerService {
  static AudioPlayer? _player;
  static bool _isVibrating = false;
  static bool _isFlashing = false;

  static Future<void> playSound({bool loop = false}) async {
    try {
      _player ??= AudioPlayer();
      await _player!.stop();
      await _player!.play(
        AssetSource('sounds/alarm.mp3'),
        volume: 1.0,
        // Looping is not directly supported in audioplayers 5.x, so we can replay onComplete if needed
      );
      if (loop) {
        _player!.onPlayerComplete.listen((event) {
          if (_player != null) {
            _player!.play(AssetSource('sounds/alarm.mp3'));
          }
        });
      }
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  static Future<void> stopSound() async {
    try {
      await _player?.stop();
    } catch (e) {
      debugPrint('Error stopping sound: $e');
    }
  }

  static Future<void> vibrateDevice({bool repeat = false}) async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        _isVibrating = true;
        if (repeat) {
          while (_isVibrating) {
            Vibration.vibrate(duration: 1000);
            await Future.delayed(const Duration(milliseconds: 1200));
          }
        } else {
          Vibration.vibrate(duration: 1000);
        }
      }
    } catch (e) {
      debugPrint('Error vibrating device: $e');
    }
  }

  static void stopVibration() {
    _isVibrating = false;
    Vibration.cancel();
  }

  static Future<void> flashLight({bool repeat = false}) async {
    try {
      _isFlashing = true;
      if (repeat) {
        while (_isFlashing) {
          await TorchLight.enableTorch();
          await Future.delayed(const Duration(milliseconds: 500));
          await TorchLight.disableTorch();
          await Future.delayed(const Duration(milliseconds: 500));
        }
      } else {
        await TorchLight.enableTorch();
        await Future.delayed(const Duration(seconds: 2));
        await TorchLight.disableTorch();
      }
    } catch (e) {
      debugPrint('Error using flashlight: $e');
    }
  }

  static void stopFlashLight() {
    _isFlashing = false;
    TorchLight.disableTorch();
  }

  static Future<void> showColorFlash(BuildContext context,
      {bool manualStop = false}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: manualStop
                ? null
                : () {
                    Navigator.pop(context);
                  },
            child: Container(
              color: const Color(0xE6FF0000), // 0xE6 = 90% alpha
              child: Center(
                child: manualStop
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'FLASH!',
                            style: TextStyle(fontSize: 48, color: Colors.white),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Stop'),
                          ),
                        ],
                      )
                    : const Text(
                        'FLASH!',
                        style: TextStyle(fontSize: 48, color: Colors.white),
                      ),
              ),
            ),
          );
        },
      ),
    );
    return;
  }

  static Future<void> triggerAll({
    required BuildContext context,
    required bool sound,
    required bool vibration,
    required bool colorFlash,
    required bool flashlight,
    bool manualStop = false,
  }) async {
    // Start all triggers
    List<Future> futures = [];
    if (sound) futures.add(playSound(loop: manualStop));
    if (vibration) futures.add(vibrateDevice(repeat: manualStop));
    if (flashlight) futures.add(flashLight(repeat: manualStop));
    if (colorFlash)
      futures.add(showColorFlash(context, manualStop: manualStop));

    if (manualStop) {
      // Wait for colorFlash dialog to close (user presses Stop)
      await Future.wait(futures);
      // Stop all triggers
      await stopAll();
    } else {
      // Auto-stop after 5 seconds
      await Future.wait([
        Future.delayed(const Duration(seconds: 5)),
        ...futures,
      ]);
      await stopAll();
    }
  }

  static Future<void> stopAll() async {
    await stopSound();
    stopVibration();
    stopFlashLight();
  }
}
