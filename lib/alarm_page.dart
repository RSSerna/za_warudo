import 'package:flutter/material.dart';

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
