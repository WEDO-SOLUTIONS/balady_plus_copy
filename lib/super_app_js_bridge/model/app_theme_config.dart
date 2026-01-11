import 'dart:ui';

import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:flutter/material.dart';

class AppThemeConfig implements BaseData {
  final String language;
  final String themeType;
  final ColorSchemeModel? colorSchemeLight;
  final ColorSchemeModel? colorSchemeDark;

  AppThemeConfig({
    required this.language,
    required this.themeType,
    required this.colorSchemeLight,
    required this.colorSchemeDark,
  });

  factory AppThemeConfig.fromJson(Map<String, dynamic> json) {
    return AppThemeConfig(
      language: json['language'] ?? 'ar',
      themeType: json['themeType'] ?? 'light',
      colorSchemeLight: json['colorSchemeLight']
          ? ColorSchemeModel.fromJson(json['colorSchemeLight'])
          : null,
      colorSchemeDark: json['colorSchemeDark']
          ? ColorSchemeModel.fromJson(json['colorSchemeDark'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'themeType': themeType,
      'colorSchemeLight': colorSchemeLight?.toJson(),
      'colorSchemeDark': colorSchemeDark?.toJson(),
    };
  }
}

class ColorSchemeModel {
  ColorScheme colorScheme;
  final Color cardColor;
  final Color scaffoldBackgroundColor;

  ColorSchemeModel({
    required this.colorScheme,
    required this.cardColor,
    required this.scaffoldBackgroundColor,
  });

  factory ColorSchemeModel.fromJson(Map<String, dynamic> json) {
    return ColorSchemeModel(
      colorScheme: ColorScheme(
        primary: Color(json['primary']),
        onPrimary: Color(json['onPrimary']),
        secondary: Color(json['secondary']),
        onSecondary: Color(json['onSecondary']),
        error: Color(json['error']),
        onError: Color(json['onError']),
        surface: Color(json['surface']),
        onSurface: Color(json['onSurface']),
        brightness:
            json['brightness'] == "dark" ? Brightness.dark : Brightness.light,
      ),
      cardColor: Color(json['cardColor']),
      scaffoldBackgroundColor: Color(json['scaffoldBackgroundColor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primary': colorScheme.primary,
      'onPrimary': colorScheme.onPrimary,
      'secondary': colorScheme.secondary,
      'onSecondary': colorScheme.onSecondary,
      'error': colorScheme.error,
      'onError': colorScheme.onError,
      'surface': colorScheme.surface,
      'onSurface': colorScheme.onSurface,
      'brightness': colorScheme.brightness.name,
      'cardColor': cardColor,
      'scaffoldBackgroundColor': scaffoldBackgroundColor,
    };
  }
}
