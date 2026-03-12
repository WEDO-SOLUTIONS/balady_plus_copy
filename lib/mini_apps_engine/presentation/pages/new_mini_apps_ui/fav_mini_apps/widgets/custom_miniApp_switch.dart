import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMiniAppSwitch extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool>? onChanged;

  const CustomMiniAppSwitch({
    super.key,
    required this.isActive,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: isActive,
      onChanged: onChanged,
      // iOS green (systemGreen)
      activeTrackColor: const Color(0xFF2AB3A9),
      // iOS inactive track color
      inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.onSurface.withAlpha(90)
          : Theme.of(context).hoverColor,
    );
  }
}
