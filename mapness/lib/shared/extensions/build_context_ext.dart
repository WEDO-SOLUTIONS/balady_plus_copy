import 'package:balady_plus/app/features/accecipilities/balady_theme_controller.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

extension BuildContextExt on BuildContext {
  bool get isLTR => Directionality.of(this) == TextDirection.ltr;

  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Card surface used across profile/settings screens (matches Settings page).
  Color get profileCardColor {
    final theme = read<ThemeController>().currentTheme;
    final isDGA = theme == BaladyAppThemes.darkDGA || theme == BaladyAppThemes.lightDGA;
    return isDGA ? colors.accentSecondarySoft : colors.backgroundSurface1;
  }
}
