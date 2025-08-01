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
    // Feedback: vibrate or play sound
    TriggerService.vibrateDevice(repeat: false);
    _tick();
  }

  void _tick() {
    if (!isRunning) return;
    if (remaining.inSeconds <= 0) {
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
      return;
    }
    Future.delayed(const Duration(seconds: 1), () {
      if (!isRunning) return;
      if (!isPaused) {
        setState(() {
          remaining = remaining - const Duration(seconds: 1);
        });
      }
      _tick();
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
    // Feedback: vibrate or play sound
    TriggerService.vibrateDevice(repeat: false);
  }

  void resumeTimer() {
    setState(() {
      isPaused = false;
    });
    // Feedback: vibrate or play sound
    TriggerService.vibrateDevice(repeat: false);
  }

  void cancelTimer() {
    setState(() {
      isRunning = false;
      isPaused = false;
      remaining = timerDuration;
    });
    // Feedback: vibrate or play sound
    TriggerService.vibrateDevice(repeat: false);
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
            SwitchListTile(
              title: const Text('Sound'),
              value: sound,
              onChanged: (val) => setState(() => sound = val),
            ),
            SwitchListTile(
              title: const Text('Vibration'),
              value: vibration,
              onChanged: (val) => setState(() => vibration = val),
            ),
            SwitchListTile(
              title: const Text('Color Flash'),
              value: colorFlash,
              onChanged: (val) => setState(() => colorFlash = val),
            ),
            SwitchListTile(
              title: const Text('Flashlight'),
              value: flashlight,
              onChanged: (val) => setState(() => flashlight = val),
            ),
            SwitchListTile(
              title: const Text('Manual Stop (show Stop button)'),
              value: manualStop,
              onChanged: (val) => setState(() => manualStop = val),
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
