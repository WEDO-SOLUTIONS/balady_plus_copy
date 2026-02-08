import 'package:balady_uikit/core/colors/app_colors_theme.dart';
import 'package:balady_uikit/core/colors/app_static_colors_theme.dart';
import 'package:balady_uikit/core/colors/colors_v2/app_colors_theme_v2.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  @Deprecated('Old text style. Use [context.textStyles] now')
  ThemeTextStyles get textStyle => Theme.of(this).extension<ThemeTextStyles>()!;
  @Deprecated('Renamed. Use [context.textStyles] now')
  ThemeTextStylesV3 get textStyleV3 => Theme.of(this).extension<ThemeTextStylesV3>()!;

  ThemeTextStylesV3 get textStyles => textStyleV3;

  @Deprecated('Old color palette. Use [context.colors] now')
  AppColorsThemeExt get color => Theme.of(this).extension<AppColorsThemeExt>()!;
  @Deprecated('Old color palette. Use [context.colors] now')
  AppColorsThemeV2 get colorsV2 => Theme.of(this).extension<AppColorsThemeV2>()!;
  @Deprecated('Renamed. Use [context.colors] now')
  AppColorsThemeV3 get colorsV3 => Theme.of(this).extension<AppColorsThemeV3>()!;

  AppColorsThemeV3 get colors => colorsV3;

  @Deprecated('Old color palette. Use static colors from [context.colors] now')
  AppStaticColorsThemeExt get staticColor => Theme.of(this).extension<AppStaticColorsThemeExt>()!;

  Locale get locale => Localizations.localeOf(this);
}
