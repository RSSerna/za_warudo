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
  Duration timerDuration = const Duration(seconds: 10);
  bool isRunning = false;
  bool manualStop = false;

  Duration remaining = Duration.zero;
  void startTimer() {
    setState(() {
      isRunning = true;
      remaining = timerDuration;
    });
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
      setState(() {
        remaining = remaining - const Duration(seconds: 1);
      });
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
