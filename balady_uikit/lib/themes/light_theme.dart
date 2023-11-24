import 'package:balady_uikit/typography/palette.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

ThemeData createLightTheme() {
  return ThemeData(
    textTheme: ThemeTextStyles.english,
    scaffoldBackgroundColor: Palette.black,
    extensions: <ThemeExtension<dynamic>>[
      ThemeTextStyles.english,
      ThemeTextStyles.arabic,
    ],
    appBarTheme: AppBarTheme(
        color: Colors.white,
        iconTheme: const IconThemeData(color: Colors.amber),
        titleTextStyle: ThemeTextStyles.arabic.headingXL),
  );
}
