import 'dart:async';

import 'package:flutter/material.dart';
import 'package:za_warudo/helpers.dart';
import 'package:za_warudo/trigger_service.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool sound = false;
  bool vibration = false;
  bool colorFlash = false;
  bool flashlight = false;
  bool isRunning = false;
  bool manualStop = false;
  bool isPaused = false;
  Duration timerDuration = const Duration(seconds: 10);
  Duration remaining = Duration.zero;
  Timer? _timer;

  void startTimer() {
    if (timerDuration.inSeconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a non-zero duration.')),
      );
      return;
    }
    setState(() {
      isRunning = true;
      isPaused = false;
      remaining = timerDuration;
    });
    TriggerService.vibrateDevice(repeat: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isRunning) {
        timer.cancel();
        return;
      }
      if (!isPaused) {
        setState(() {
          remaining = remaining - const Duration(seconds: 1);
        });
      }
      if (remaining.inSeconds <= 0) {
        timer.cancel();
        setState(() {
          isRunning = false;
        });
        TriggerService.triggerAll(
          context: context,
          sound: sound,
          vibration: vibration,
          colorFlash: colorFlash,
          flashlight: flashlight,
          manualStop: manualStop,
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
    setState(() {
      isPaused = true;
    });
    TriggerService.vibrateDevice(repeat: false);
  }

  void resumeTimer() {
    setState(() {
      isPaused = false;
    });
    TriggerService.vibrateDevice(repeat: false);
  }

  void cancelTimer() {
    setState(() {
      isRunning = false;
      isPaused = false;
      remaining = timerDuration;
    });
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
    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Timer Duration'),
            subtitle: Text(_formatDuration(timerDuration)),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: isRunning
                  ? null
                  : () async {
                      Duration? picked = await showDurationPicker(
                        context: context,
                        initialTime: timerDuration,
                      );
                      if (picked != null) {
                        setState(() {
                          timerDuration = picked;
                        });
                      }
                    },
            ),
          ),
          if (!isRunning) ...[
            TimerSwitches(
              sound: sound,
              vibration: vibration,
              colorFlash: colorFlash,
              flashlight: flashlight,
              manualStop: manualStop,
              onChanged: (String key, bool value) {
                setState(() {
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
                });
              },
            ),
            ElevatedButton(
              onPressed: isRunning ? null : startTimer,
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
              _formatDuration(remaining),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: timerDuration.inSeconds > 0
                  ? remaining.inSeconds / timerDuration.inSeconds
                  : 0,
              minHeight: 8,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isPaused)
                  ElevatedButton(
                    onPressed: pauseTimer,
                    child: const Text('Pause'),
                  ),
                if (isPaused)
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
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class TimerSwitches extends StatelessWidget {
  final bool sound;
  final bool vibration;
  final bool colorFlash;
  final bool flashlight;
  final bool manualStop;
  final void Function(String, bool) onChanged;

  const TimerSwitches({
    super.key,
    required this.sound,
    required this.vibration,
    required this.colorFlash,
    required this.flashlight,
    required this.manualStop,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Sound'),
          value: sound,
          onChanged: (val) => onChanged('sound', val),
        ),
        SwitchListTile(
          title: const Text('Vibration'),
          value: vibration,
          onChanged: (val) => onChanged('vibration', val),
        ),
        SwitchListTile(
          title: const Text('Color Flash'),
          value: colorFlash,
          onChanged: (val) => onChanged('colorFlash', val),
        ),
        SwitchListTile(
          title: const Text('Flashlight'),
          value: flashlight,
          onChanged: (val) => onChanged('flashlight', val),
        ),
        SwitchListTile(
          title: const Text('Manual Stop (show Stop button)'),
          value: manualStop,
          onChanged: (val) => onChanged('manualStop', val),
        ),
      ],
    );
  }
}
