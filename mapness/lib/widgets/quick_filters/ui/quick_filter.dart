import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/features/special_themes/modes/mekkah_base/makkah_poi_constants.dart';
import 'package:mapness/pages/bottom_menu/bottom_sheet_controllers.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';

class QuickFilter extends ConsumerWidget {
  final FilterItemConfig item;
  final bool selected;
  final ChipsType chipsType;

  const QuickFilter({required this.item, required this.selected, this.chipsType = ChipsType.neutral, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(activeBottomSheetControllerProvider);

    final colors = context.colors;

    final specialThemeMode = ref.watch(specialThemeModeProvider);
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;

    final bool isMekkahTheme =
        specialThemeMode == SpecialThemeMode.mekkahBase || specialThemeMode == SpecialThemeMode.ramadan;

    final Color lightThemedColor = specialThemeMode == SpecialThemeMode.ramadan
        ? const Color(0xFF806E5C)
        : const Color(0xFF307457);

    // Dark Makkah uses white chrome inside the dark navy chip; the gold/green
    // tints from the light Makkah palette wash out.
    final Color themedColor = isDark ? const Color(0xFFFFFFFF) : lightThemedColor;

    final Color iconColor = isMekkahTheme ? themedColor : colors.foregroundSoft;
    final Color? labelColor = isMekkahTheme ? themedColor : null;

    final leadingIcon = item.icon != null
        ? ChipIconWidget(
            ({color}) => Icon(item.icon, size: 18, color: color ?? iconColor),
          )
        : null;
    final label = item.title;

    final Color chipBackground = isMekkahTheme && isDark
        ? MakkahPoiConstants.darkSheet
        : context.colors.backgroundSurface2;
    final Color chipForeground = isMekkahTheme && isDark ? const Color(0xFFFFFFFF) : context.colors.foregroundDefault;
    final WidgetColors chipsColors = WidgetColors(
      background: chipBackground,
      foreground: chipForeground,
    );

    if (label == null || label.isEmpty == true) {
      if (leadingIcon == null) {
        return const SizedBox.shrink();
      }
      final chip = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusBorder.m),
          border: Border.all(
            color: context.colors.borderDefault,
            width: 0,
          ),
        ),
        child: ChipsElement(
          colors: chipsColors,
          onPressed: item.onTap,
          isSelected: item.selected,
          type: chipsType,
          options: ChipsIconOptions(icon: leadingIcon, color: iconColor),
        ),
      );
      final a11yLabel = item.semanticsLabel;
      if (a11yLabel != null && a11yLabel.isNotEmpty) {
        return Semantics(
          label: a11yLabel,
          button: true,
          child: ExcludeSemantics(child: chip),
        );
      }
      return chip;
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RadiusBorder.m),
        border: Border.all(
          color: context.colors.borderDefault,
          width: 0,
        ),
      ),
      child: ChipsElement(
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
