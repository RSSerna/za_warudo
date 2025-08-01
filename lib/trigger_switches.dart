import 'package:flutter/material.dart';

class TriggerSwitches extends StatelessWidget {
  final bool sound;
  final bool vibration;
  final bool colorFlash;
  final bool flashlight;
  final bool manualStop;
  final void Function(String, bool) onChanged;

  const TriggerSwitches({
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
