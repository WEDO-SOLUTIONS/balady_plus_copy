import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';

class QuickFilter extends StatelessWidget {
  final FilterItemConfig item;
  final bool selected;
  final ChipsType chipsType;

  const QuickFilter({
    required this.item,
    required this.selected,
    this.chipsType = ChipsType.neutral,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final leadingIcon = item.icon != null
        ? ChipIconWidgetV2(
            ({color}) => Icon(
              item.icon,
              size: 24,
              color: context.colorsV3.foregroundSoft,
            ),
          )
        : null;
    final label = item.title;
    if (label == null || label.isEmpty == true) {
      if (leadingIcon == null) {
        return const SizedBox.shrink();
      }
      return ChipsElement(
        onPressed: item.onTap,
        isSelected: item.selected,
        type: chipsType,
        options: ChipsIconOptions(icon: leadingIcon),
      );
    }
    return ChipsElement(
      onPressed: item.onTap,
      isSelected: item.selected,
      type: chipsType,
      options: ChipsLabelOptions(labelFirst: label, leadingIcon: leadingIcon),
    );
  }
}
