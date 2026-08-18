import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Approved lifestyle green for POI/search action buttons.
const kLifestyleAccentGreen = Color(0xFF1B8354);

const _buttonColorScheme = ButtonColorScheme.accentSecondary;
const _borderRadius = 4.0;
const _labeledIconSize = 15.0;
const _iconOnlyIconSize = 20.0;
const _labeledInnerPadding = EdgeInsetsDirectional.symmetric(
  vertical: Spacing.$2x,
  horizontal: Spacing.$4x,
);
const _iconOnlyInnerPadding = EdgeInsets.all(Spacing.$2x);

class LifestyleActionBarStyle {
  final BorderSide secondaryBorder;
  final Color secondaryBackground;
  final Color directionsForeground;

  const LifestyleActionBarStyle({
    required this.secondaryBorder,
    required this.secondaryBackground,
    required this.directionsForeground,
  });

  factory LifestyleActionBarStyle.of(BuildContext context) {
    final colors = context.colors;
    final theme = context.read<ThemeController>().currentTheme;
    final isDgaDark = theme == BaladyAppThemes.darkDGA;
    final isDgaLight = theme == BaladyAppThemes.lightDGA;

    return LifestyleActionBarStyle(
      secondaryBorder: BorderSide(color: colors.borderDefault),
      secondaryBackground: isDgaDark
          ? colors.neutralMuted
          : isDgaLight
          ? colors.neutralOnNeutral
          : colors.backgroundSurface1,
      directionsForeground: colors.staticWhite,
    );
  }

  static bool isEnabled(WidgetRef ref) => ref.watch(specialThemeModeProvider) == SpecialThemeMode.base;

  ItemActionBar directions({
    required BuildContext context,
    required VoidCallback onPressed,
  }) => ItemActionBar(
    icon: TransportIcons.locationDirectionNavigator,
    buttonType: ButtonType.secondary,
    colorScheme: _buttonColorScheme,
    label: context.l10n.poiCardDirections,
    innerPadding: _labeledInnerPadding,
    bgColor: kLifestyleAccentGreen,
    labelColor: directionsForeground,
    iconColor: directionsForeground,
    iconSize: _labeledIconSize,
    onPressed: onPressed,
  );

  ItemActionBar secondary({
    required IconData icon,
    required VoidCallback onPressed,
    String? label,
    EdgeInsetsGeometry? innerPadding,
    ButtonType buttonType = ButtonType.secondary,
    Color? bgColor,
    BorderSide? border,
  }) => ItemActionBar(
    icon: icon,
    buttonType: buttonType,
    colorScheme: _buttonColorScheme,
    label: label,
    innerPadding: innerPadding ?? (label != null ? _labeledInnerPadding : _iconOnlyInnerPadding),
    border: border ?? secondaryBorder,
    borderRadius: _borderRadius,
    bgColor: bgColor ?? secondaryBackground,
    labelColor: kLifestyleAccentGreen,
    iconColor: kLifestyleAccentGreen,
    iconSize: label != null ? _labeledIconSize : _iconOnlyIconSize,
    onPressed: onPressed,
  );
}
