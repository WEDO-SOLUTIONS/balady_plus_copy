import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            ({color}) => SvgPicture.asset(
              item.icon!,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                context.colorsV3.foregroundSoft,
                BlendMode.srcIn,
              ),
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
