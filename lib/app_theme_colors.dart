
import 'package:balady_uikit/core/colors/app_colors_theme.dart';
import 'package:balady_uikit/core/colors/colors_v2/app_colors_theme_v2.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:flutter/material.dart';

import 'app/core/utils/constants/app_colors.dart';

class AppThemeColors {
  static const primary = AppColor.baladyDarkGreen2;

  // Light
  static const lightBackground = Color(0xFFF5F7FA);
  static const lightSurface = Color(0xFFF5F7FA);

  // Dark
  static const darkBackground = Color(0xFF00141C);
  static const darkSurface = Color(0xFF0B2733);

  static const error = Colors.red;

  static ThemeData buildLightTheme(String language) {
    final base = ThemeData.light(useMaterial3: false);

    const baseTextColor = Colors.black;
    final mutedTextColor = Colors.grey.shade600;

    return base.copyWith(
      brightness: Brightness.light,
      primaryColor: AppThemeColors.primary,
      scaffoldBackgroundColor: AppThemeColors.lightBackground,
      dividerColor: Colors.grey.shade300,

      // ------------------------------------------------------------
      // TEXT
      // ------------------------------------------------------------
      textTheme: base.textTheme.copyWith(
        bodyLarge: const TextStyle(color: baseTextColor),
        bodyMedium: const TextStyle(color: baseTextColor),
        bodySmall: TextStyle(color: mutedTextColor),
        titleLarge: const TextStyle(
          color: baseTextColor,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: const TextStyle(color: baseTextColor),
        labelLarge: const TextStyle(color: baseTextColor),
      ),

      iconTheme: const IconThemeData(color: baseTextColor),

      // ------------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------------
      appBarTheme: const AppBarTheme(
        backgroundColor: AppThemeColors.lightSurface,
        foregroundColor: baseTextColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: baseTextColor,
        ),
      ),

      // ------------------------------------------------------------
      // BUTTONS
      // ------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppThemeColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppThemeColors.primary,
          side: const BorderSide(color: AppThemeColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppThemeColors.primary,
        ),
      ),

      // ------------------------------------------------------------
      // INPUTS
      // ------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: mutedTextColor),
        labelStyle: const TextStyle(color: baseTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppThemeColors.primary, width: 1.5),
        ),
      ),

      // ------------------------------------------------------------
      // NAVIGATION
      // ------------------------------------------------------------
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppThemeColors.lightSurface,
        selectedItemColor: AppThemeColors.primary,
        unselectedItemColor: mutedTextColor,
        showUnselectedLabels: true,
      ),

      tabBarTheme: TabBarTheme(
        labelColor: AppThemeColors.primary,
        unselectedLabelColor: mutedTextColor,
        indicatorColor: AppThemeColors.primary,
      ),

      // ------------------------------------------------------------
      // FEEDBACK
      // ------------------------------------------------------------
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),

      // ------------------------------------------------------------
      // EXTENSIONS
      // ------------------------------------------------------------
      extensions: [
        language == "ar" ? ThemeTextStyles.arabic() : ThemeTextStyles.english(),
        language == "ar"
            ? ThemeTextStylesV3.frutiger()
            : ThemeTextStylesV3.golos(),
        AppColorsThemeExt.palette(isDark: false),
        AppColorsThemeV2.palette(isDark: false),
        AppColorsThemeV3.palette(themes: BaladyAppThemes.light),
      ],
    );
  }

  static ThemeData buildDarkTheme(String language) {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppThemeColors.primary,
      onPrimary: Colors.white,
      secondary: AppThemeColors.primary,
      onSecondary: Colors.white,
      error: AppThemeColors.error,
      onError: Colors.white,
      surface: AppThemeColors.darkSurface,
      onSurface: Colors.white,
    );

    final base = ThemeData.dark(useMaterial3: false);

    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: AppThemeColors.darkBackground,
      dividerColor: Colors.grey.shade700,
      textTheme: base.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0F2E3B),
        labelStyle: TextStyle(color: colorScheme.onSurface),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.grey.shade400,
      ),
      extensions: [
        language == "ar" ? ThemeTextStyles.arabic() : ThemeTextStyles.english(),
        language == "ar"
            ? ThemeTextStylesV3.frutiger()
            : ThemeTextStylesV3.golos(),
        AppColorsThemeExt.palette(isDark: true),
        AppColorsThemeV2.palette(isDark: true),
        AppColorsThemeV3.palette(themes: BaladyAppThemes.dark),
      ],
    );
  }
}
