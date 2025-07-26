import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer & Alarm App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer & Alarm Features')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Timer'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TimerPage()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Alarm'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlarmPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

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

// Helper for picking duration
Future<Duration?> showDurationPicker({
  required BuildContext context,
  required Duration initialTime,
}) async {
  int seconds = initialTime.inSeconds;
  Duration? result = await showDialog<Duration>(
    context: context,
    builder: (context) {
      int tempSeconds = seconds;
      return AlertDialog(
        title: const Text('Pick Duration (seconds)'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Row(
              children: [
                Expanded(
                  child: Slider(
                    min: 1,
                    max: 3600,
                    value: tempSeconds.toDouble(),
                    label: '$tempSeconds',
                    onChanged: (val) =>
                        setState(() => tempSeconds = val.toInt()),
                  ),
                ),
                Text('$tempSeconds s'),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, Duration(seconds: tempSeconds)),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
  return result;
}

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  bool sound = false;
  bool vibration = false;
  bool colorFlash = false;
  bool flashlight = false;
  TimeOfDay? alarmTime;
  bool isAlarmSet = false;

  void setAlarm() {
    if (alarmTime == null) return;
    setState(() {
      isAlarmSet = true;
    });
    final now = DateTime.now();
    final alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      alarmTime!.hour,
      alarmTime!.minute,
    );
    Duration waitDuration = alarmDateTime.isAfter(now)
        ? alarmDateTime.difference(now)
        : alarmDateTime.add(const Duration(days: 1)).difference(now);

    Future.delayed(waitDuration, () {
      setState(() {
        isAlarmSet = false;
      });
      _showAlarmDialog();
      // Here you will later trigger sound, vibration, etc.
    });
  }

  void _showAlarmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alarm!'),
        content: const Text('Your alarm is ringing.'),
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
      appBar: AppBar(title: const Text('Alarm')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Alarm Time'),
            subtitle: Text(
                alarmTime == null ? 'Not set' : alarmTime!.format(context)),
            trailing: IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    alarmTime = picked;
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
            onPressed: isAlarmSet ? null : setAlarm,
            child:
                isAlarmSet ? const Text('Alarm Set!') : const Text('Set Alarm'),
          ),
        ],
      ),
    );
  }
}
