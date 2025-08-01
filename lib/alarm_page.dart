import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:za_warudo/alarm_provider.dart';
import 'package:za_warudo/trigger_service.dart';
import 'package:za_warudo/trigger_switches.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  void setAlarm() {
    final provider = Provider.of<AlarmProvider>(context, listen: false);
    if (provider.alarmTime == null) return;
    provider.setAlarmSet(true);
    final now = DateTime.now();
    final alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      provider.alarmTime!.hour,
      provider.alarmTime!.minute,
    );
    Duration waitDuration = alarmDateTime.isAfter(now)
        ? alarmDateTime.difference(now)
        : alarmDateTime.add(const Duration(days: 1)).difference(now);

    Future.delayed(waitDuration, () async {
      provider.setAlarmSet(false);
      await TriggerService.triggerAll(
        context: context,
        sound: provider.sound,
        vibration: provider.vibration,
        colorFlash: provider.colorFlash,
        flashlight: provider.flashlight,
        manualStop: provider.manualStop,
      );
      _showAlarmDialog();
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
    return Consumer<AlarmProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Alarm')),
          body: Column(
            children: [
              ListTile(
                title: const Text('Alarm Time'),
                subtitle: Text(provider.alarmTime == null
                    ? 'Not set'
                    : provider.alarmTime!.format(context)),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      provider.setAlarmTime(picked);
                    }
                  },
                ),
              ),
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
                onPressed: provider.isAlarmSet ? null : setAlarm,
                child: provider.isAlarmSet
                    ? const Text('Alarm Set!')
                    : const Text('Set Alarm'),
              ),
            ],
          ),
        );
      },
    );
  }
}
