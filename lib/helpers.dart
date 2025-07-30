import 'package:flutter/material.dart';

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
