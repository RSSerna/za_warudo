import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;
    if (provider.timerDuration.inSeconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.pleaseSelectNonZeroDuration)),
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
        _triggerWithErrorHandling(provider);
      }
    });
  }

  void _triggerWithErrorHandling(TimerProvider provider) async {
    try {
      await TriggerService.triggerAll(
        context: context,
        sound: provider.sound,
        vibration: provider.vibration,
        colorFlash: provider.colorFlash,
        flashlight: provider.flashlight,
        manualStop: provider.manualStop,
      );
      _showTimerDialog();
    } catch (e) {
      final loc = AppLocalizations.of(context)!;
      _showErrorDialog(loc.failedToTriggerTimer(e.toString()));
    }
  }

  void _showErrorDialog(String message) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.ok),
          ),
        ],
      ),
    );
  }

  void _showTimerDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.timerDone),
        content: Text(loc.timerFinished),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.ok),
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
        final loc = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(title: Text(loc.timer)),
          body: Column(
            children: [
              ListTile(
                title: Text(loc.timerDuration),
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
                  onChanged: (key, value) => provider.setOption(key, value),
                ),
                Semantics(
                  label: loc.startTimer,
                  button: true,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: provider.isRunning ? null : startTimer,
                      child: Text(loc.startTimer,
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 32),
                Text(
                  loc.timeRemaining,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                      Semantics(
                        label: loc.pause,
                        button: true,
                        child: SizedBox(
                          width: 140,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: pauseTimer,
                            child: Text(loc.pause,
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                      ),
                    if (provider.isPaused)
                      Semantics(
                        label: loc.resume,
                        button: true,
                        child: SizedBox(
                          width: 140,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: resumeTimer,
                            child: Text(loc.resume,
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                      ),
                    const SizedBox(width: 16),
                    Semantics(
                      label: loc.cancel,
                      button: true,
                      child: SizedBox(
                        width: 140,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: cancelTimer,
                          child: Text(loc.cancel,
                              style: const TextStyle(fontSize: 20)),
                        ),
                      ),
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
