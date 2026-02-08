import 'package:balady_uikit/core/colors/app_colors_theme.dart';
import 'package:balady_uikit/core/colors/app_static_colors_theme.dart';
import 'package:balady_uikit/core/colors/colors_v2/app_colors_theme_v2.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:flutter/material.dart';

ThemeData createAppLightTheme() => ThemeData.light().copyWith(
      extensions: <ThemeExtension<dynamic>>[
        AppColorsThemeExt.palette(isDark: false),
        AppStaticColorsThemeExt.palette(),
        AppColorsThemeV2.palette(isDark: false),
        AppColorsThemeV3.palette(themes: BaladyAppThemes.light),
      ],
    );
