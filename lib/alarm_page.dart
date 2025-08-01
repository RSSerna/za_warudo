import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  void _resetSound(AlarmProvider provider) {
    provider.setAlarmSoundPath(null);
  }

  Future<void> _pickSoundFile(AlarmProvider provider) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      await provider.setAlarmSoundPath(result.files.single.path);
    }
  }

  void setAlarm() {
    final provider = Provider.of<AlarmProvider>(context, listen: false);
    final loc = AppLocalizations.of(context)!;
    if (provider.alarmTime == null) {
      _showErrorDialog(loc.pleaseSetAlarmTime);
      return;
    }
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
      try {
        await TriggerService.triggerAll(
          context: context,
          sound: provider.sound,
          vibration: provider.vibration,
          colorFlash: provider.colorFlash,
          flashlight: provider.flashlight,
          manualStop: provider.manualStop,
          soundPath: provider.alarmSoundPath,
        );
        _showAlarmDialog();
      } catch (e) {
        _showErrorDialog(loc.failedToTriggerAlarm(e.toString()));
      }
    });
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

  void _showAlarmDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.alarm),
        content: Text(loc.alarmRinging),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlarmProvider>(
      builder: (context, provider, child) {
        final loc = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(title: Text(loc.alarm)),
          body: Column(
            children: [
              ListTile(
                title: Text(loc.alarmTime),
                subtitle: Text(provider.alarmTime == null
                    ? loc.notSet
                    : provider.alarmTime!.format(context)),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: provider.alarmTime ?? TimeOfDay.now(),
                    );
                    if (picked != null) {
                      provider.setAlarmTime(picked);
                    }
                  },
                ),
              ),
              ListTile(
                title: Text('Custom Alarm Sound'),
                subtitle: Text(
                  provider.alarmSoundPath != null
                      ? provider.alarmSoundPath!.split(RegExp(r'[\\/]')).last
                      : 'Default',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.music_note),
                      onPressed: () => _pickSoundFile(provider),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Reset to default',
                      onPressed: provider.alarmSoundPath == null
                          ? null
                          : () => _resetSound(provider),
                    ),
                  ],
                ),
              ),
              TriggerSwitches(
                sound: provider.sound,
                vibration: provider.vibration,
                colorFlash: provider.colorFlash,
                flashlight: provider.flashlight,
                manualStop: provider.manualStop,
                onChanged: (key, value) => provider.setOption(key, value),
              ),
              Semantics(
                label: provider.isAlarmSet ? loc.alarmSet : loc.setAlarm,
                button: true,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: provider.isAlarmSet ? null : setAlarm,
                    child: Text(
                      provider.isAlarmSet ? loc.alarmSet : loc.setAlarm,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
