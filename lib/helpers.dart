import 'package:flutter/material.dart';

Future<Duration?> showDurationPicker({
  required BuildContext context,
  required Duration initialTime,
}) async {
  int initialHours = initialTime.inHours;
  int initialMinutes = initialTime.inMinutes % 60;
  int initialSeconds = initialTime.inSeconds % 60;
  int hours = initialHours;
  int minutes = initialMinutes;
  int seconds = initialSeconds;
  Duration? result = await showDialog<Duration>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Pick Duration'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<int>(
                      value: hours,
                      items: List.generate(
                          24,
                          (i) =>
                              DropdownMenuItem(value: i, child: Text('$i h'))),
                      onChanged: (val) => setState(() => hours = val ?? 0),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: minutes,
                      items: List.generate(
                          60,
                          (i) =>
                              DropdownMenuItem(value: i, child: Text('$i m'))),
                      onChanged: (val) => setState(() => minutes = val ?? 0),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: seconds,
                      items: List.generate(
                          60,
                          (i) =>
                              DropdownMenuItem(value: i, child: Text('$i s'))),
                      onChanged: (val) => setState(() => seconds = val ?? 0),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Selected (HH:MM:SS): '
                    '${hours.toString().padLeft(2, '0')}:'
                    '${minutes.toString().padLeft(2, '0')}:'
                    '${seconds.toString().padLeft(2, '0')}'),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context,
                  Duration(hours: hours, minutes: minutes, seconds: seconds));
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
  return result;
}
