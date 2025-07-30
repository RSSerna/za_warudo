import 'package:flutter/material.dart';
import 'package:za_warudo/helpers.dart';

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

  void startTimer() {
    setState(() {
      isRunning = true;
    });
    Future.delayed(timerDuration, () {
      setState(() {
        isRunning = false;
      });
      _showTimerDialog();
      // Here you will later trigger sound, vibration, etc.
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
            subtitle: Text('${timerDuration.inSeconds} seconds'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
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
          ElevatedButton(
            onPressed: isRunning ? null : startTimer,
            child: isRunning
                ? const Text('Running...')
                : const Text('Start Timer'),
          ),
        ],
      ),
    );
  }
}
