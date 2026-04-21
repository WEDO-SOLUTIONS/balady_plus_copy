import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/pages/landing/landing_page.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';

class QuickFilter extends ConsumerWidget {
  final FilterItemConfig item;
  final bool selected;
  final ChipsType chipsType;

  const QuickFilter({required this.item, required this.selected, this.chipsType = ChipsType.neutral, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerWrapper = ref.watch(bottomSheetControllerProvider);
    final controller = controllerWrapper.controller;

    final colors = context.colors;

    final specialThemeMode = ref.watch(specialThemeModeProvider);

    final bool isMekkahTheme =
        specialThemeMode == SpecialThemeMode.mekkahBase || specialThemeMode == SpecialThemeMode.ramadan;

    final Color themedColor = specialThemeMode == SpecialThemeMode.ramadan
        ? const Color(0xFF806E5C)
        : const Color(0xFF307457);

    final Color iconColor = isMekkahTheme ? themedColor : colors.foregroundSoft;
    final Color? labelColor = isMekkahTheme ? themedColor : null;

    final leadingIcon = item.icon != null
        ? ChipIconWidget(
            ({color}) => Icon(item.icon, size: 18, color: color ?? iconColor),
          )
        : null;
    final label = item.title;

    final WidgetColors chipsColors = WidgetColors(
      background: context.colors.backgroundSurface2,
      foreground: context.colors.foregroundDefault,
    );

    if (label == null || label.isEmpty == true) {
      if (leadingIcon == null) {
        return const SizedBox.shrink();
      }
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: context.colors.borderMuted,
            width: 1,
          ),
        ),

        child:  ChipsElement(
        colors: chipsColors,
        onPressed: item.onTap,
        isSelected: item.selected,
        type: chipsType,
        options: ChipsIconOptions(icon: leadingIcon, color: iconColor),
        ), );
    }
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: context.colors.borderMuted,
            width: 1,
          ),
        ),

        child:  ChipsElement(
      colors: chipsColors,
      onPressed: item.onTap,
      isSelected: item.selected,
      type: chipsType,
      options: ChipsLabelOptions(
        labelFirst: label,
        leadingIcon: leadingIcon,
        leadingIconColor: iconColor,
        labelFirstColor: labelColor,
      ),
        ),
    );
  }
}
