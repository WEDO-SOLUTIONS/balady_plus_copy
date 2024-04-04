import 'package:balady_uikit/core/colors/app_colors_theme.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension BuildContextExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  ThemeTextStyles get textStyle => Theme.of(this).extension<ThemeTextStyles>()!;

  AppColorsThemeExt get color =>
      Theme.of(this).extension<AppColorsThemeExt>()!;
}
