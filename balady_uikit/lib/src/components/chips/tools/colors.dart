import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/src/common/state_colors.dart';
import 'package:balady_uikit/src/components/chips/chips_types.dart';

/// Get the colors of the chips based on the type, selected state, enabled state and pressed state
/// The colors are based on the [AppColorsThemeV3]
WidgetColors getChipsColors({
  required AppColorsThemeV3 colors,
  required ChipsType type,
  required bool isSelected,
  required bool isEnabled,
  required bool isPressed,
}) {
  final bgColors = _getBackgroundSet(colors: colors, type: type, isSelected: isSelected);
  final frontColors = _getForegroundsSet(colors: colors, type: type, isSelected: isSelected);
  if (!isEnabled) {
    return WidgetColors(
      background: bgColors.disabled,
      foreground: frontColors.disabled,
    );
  }
  if (isPressed) {
    return WidgetColors(
      background: bgColors.pressed,
      foreground: frontColors.pressed,
    );
  }
  return WidgetColors(
    background: bgColors.defaultValue,
    foreground: frontColors.defaultValue,
  );
}

/// Get the background colors of the chips based on the type, selected state and enabled state
/// The set of colors contains the default, pressed and disabled colors
WidgetStateColors _getBackgroundSet({
  required AppColorsThemeV3 colors,
  required ChipsType type,
  required bool isSelected,
}) {
  final selectedColors = WidgetStateColors(
    defaultValue: colors.neutralDefault,
    pressed: colors.neutralActive,
    disabled: colors.neutralMuted,
  );
  if (isSelected) return selectedColors;
  return switch (type) {
    ChipsType.neutral => WidgetStateColors(
        defaultValue: colors.neutralContainerDefault,
        pressed: colors.neutralContainerActive,
        disabled: colors.backgroundSurface4,
      ),
    ChipsType.map => WidgetStateColors(
        defaultValue: colors.backgroundSurface1,
        pressed: colors.backgroundSurface5,
        disabled: colors.backgroundSurface1,
      ),
    ChipsType.accent => WidgetStateColors(
        defaultValue: colors.accentDefault,
        pressed: colors.accentActive,
        disabled: colors.neutralMuted,
      ),
    ChipsType.accentSecondary => WidgetStateColors(
        defaultValue: colors.accentSecondaryDefault,
        pressed: colors.accentSecondaryActive,
        disabled: colors.neutralMuted,
      )
  };
}

/// Get the foreground colors of the chips based on the type, selected state and enabled state
/// The set of colors contains the default, pressed and disabled colors
WidgetStateColors _getForegroundsSet(
    {required AppColorsThemeV3 colors, required ChipsType type, required bool isSelected}) {
  final selectedColors = WidgetStateColors(
    defaultValue: colors.neutralOnNeutral,
    pressed: colors.neutralOnNeutral,
    disabled: colors.neutralOnNeutral,
  );
  if (isSelected) return selectedColors;

  return switch (type) {
    ChipsType.neutral => WidgetStateColors(
        defaultValue: colors.foregroundDefault,
        pressed: colors.foregroundDefault,
        disabled: colors.foregroundDisabled,
      ),
    ChipsType.map => WidgetStateColors(
        defaultValue: colors.foregroundDefault,
        pressed: colors.foregroundDefault,
        disabled: colors.foregroundDisabled,
      ),
    ChipsType.accent => WidgetStateColors(
        defaultValue: colors.accentOnAccent,
        pressed: colors.accentOnAccent,
        disabled: colors.neutralOnNeutral,
      ),
    ChipsType.accentSecondary => WidgetStateColors(
        defaultValue: colors.accentSecondaryOnAccentSecondary,
        pressed: colors.accentSecondaryOnAccentSecondary,
        disabled: colors.neutralOnNeutral,
      )
  };
}
