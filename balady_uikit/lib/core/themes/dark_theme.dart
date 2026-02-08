import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colors/app_static_colors_theme.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:flutter/material.dart';

ThemeData createAppDarkTheme() => ThemeData.dark().copyWith(
      extensions: <ThemeExtension<dynamic>>[
        AppColorsThemeExt.palette(isDark: true),
        AppStaticColorsThemeExt.palette(),
        AppColorsThemeV2.palette(isDark: true),
        AppColorsThemeV3.palette(themes: BaladyAppThemes.dark),
      ],
    );
