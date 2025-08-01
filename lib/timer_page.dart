import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:za_warudo/helpers.dart';
import 'package:za_warudo/timer_provider.dart';
import 'package:za_warudo/trigger_service.dart';
import 'package:za_warudo/trigger_switches.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;

  void startTimer() {
    final provider = Provider.of<TimerProvider>(context, listen: false);
    if (provider.timerDuration.inSeconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a non-zero duration.')),
      );
      return;
    }
    provider.setTimerRunning(true);
    provider.setTimerPaused(false);
    provider.setTimerRemaining(provider.timerDuration);
    TriggerService.vibrateDevice(repeat: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!provider.isRunning) {
        timer.cancel();
        return;
      }
      if (!provider.isPaused) {
        provider
            .setTimerRemaining(provider.remaining - const Duration(seconds: 1));
      }
      if (provider.remaining.inSeconds <= 0) {
        timer.cancel();
        provider.setTimerRunning(false);
        TriggerService.triggerAll(
          context: context,
          sound: provider.sound,
          vibration: provider.vibration,
          colorFlash: provider.colorFlash,
          flashlight: provider.flashlight,
          manualStop: provider.manualStop,
        ).then((_) => _showTimerDialog());
      }
    });
  }

  void _showTimerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Timer Done!'),
        content: const Text('Your timer has finished.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void pauseTimer() {
    final provider = Provider.of<TimerProvider>(context, listen: false);
    provider.setTimerPaused(true);
    TriggerService.vibrateDevice(repeat: false);
  }

  void resumeTimer() {
    final provider = Provider.of<TimerProvider>(context, listen: false);
    provider.setTimerPaused(false);
    TriggerService.vibrateDevice(repeat: false);
  }

  void cancelTimer() {
    final provider = Provider.of<TimerProvider>(context, listen: false);
    provider.setTimerRunning(false);
    provider.setTimerPaused(false);
    provider.setTimerRemaining(provider.timerDuration);
    _timer?.cancel();
    TriggerService.vibrateDevice(repeat: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Timer')),
          body: Column(
            children: [
              ListTile(
                title: const Text('Timer Duration'),
                subtitle: Text(_formatDuration(provider.timerDuration)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: provider.isRunning
                      ? null
                      : () async {
                          Duration? picked = await showDurationPicker(
                            context: context,
                            initialTime: provider.timerDuration,
                          );
                          if (picked != null) {
                            provider.setTimerDuration(picked);
                          }
                        },
                ),
              ),
              if (!provider.isRunning) ...[
                TriggerSwitches(
                  sound: provider.sound,
                  vibration: provider.vibration,
                  colorFlash: provider.colorFlash,
                  flashlight: provider.flashlight,
                  manualStop: provider.manualStop,
                  onChanged: (String key, bool value) {
                    provider.setOption(key, value);
                  },
                ),
                ElevatedButton(
                  onPressed: provider.isRunning ? null : startTimer,
                  child: const Text('Start Timer'),
                ),
              ] else ...[
                const SizedBox(height: 32),
                Text(
                  'Time Remaining',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  _formatDuration(provider.remaining),
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: provider.timerDuration.inSeconds > 0
                      ? provider.remaining.inSeconds /
                          provider.timerDuration.inSeconds
                      : 0,
                  minHeight: 8,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!provider.isPaused)
                      ElevatedButton(
                        onPressed: pauseTimer,
                        child: const Text('Pause'),
                      ),
                    if (provider.isPaused)
                      ElevatedButton(
                        onPressed: resumeTimer,
                        child: const Text('Resume'),
                      ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: cancelTimer,
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
