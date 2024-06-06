import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colors/app_static_colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension BuildContextExt on BuildContext {
  bool get isLTR => Directionality.of(this) == TextDirection.ltr;

  AppLocalizations get l10n => AppLocalizations.of(this);

  ThemeTextStyles get textStyle => Theme.of(this).extension<ThemeTextStyles>()!;

  AppColorsThemeExt get color => Theme.of(this).extension<AppColorsThemeExt>()!;

  AppStaticColorsThemeExt get staticColor =>
      Theme.of(this).extension<AppStaticColorsThemeExt>()!;
}
