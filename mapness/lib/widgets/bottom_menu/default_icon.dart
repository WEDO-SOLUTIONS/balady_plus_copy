import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class DefaultIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;

  const DefaultIcon({
    required this.icon,
    required this.selected,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Icon(
        icon,
        size: 24,
        color: selected ? context.colors.accentDefault : context.colors.foregroundSoft,
      );
}
