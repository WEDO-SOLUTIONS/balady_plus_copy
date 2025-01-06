import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class DefaultLabel extends StatelessWidget {
  final String label;
  final bool selected;

  const DefaultLabel({
    required this.label,
    required this.selected,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: context.textStyleV3.captionSmallMedium.copyWith(
          color: selected ? context.colorsV2.accentDefault : context.colorsV2.foregroundSoft,
        ),
      );
}
