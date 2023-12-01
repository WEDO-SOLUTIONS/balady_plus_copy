import 'package:balady_uikit/typography/palette.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

ThemeData createDarkTheme() {
  return ThemeData(
    textTheme: ThemeTextStyles.english(isDark: true),
    scaffoldBackgroundColor: Palette.black,
    extensions: <ThemeExtension<dynamic>>[
      ThemeTextStyles.english(isDark: true),
      ThemeTextStyles.arabic(isDark: true),
    ],
    appBarTheme: AppBarTheme(
        color: Colors.white,
        iconTheme: const IconThemeData(color: Colors.amber),
        titleTextStyle: ThemeTextStyles.arabic(isDark: true).headingXL),
  );
}
