
import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:flutter/material.dart';

import '../../app/features/accecipilities/AccessibilitySettings.dart';

class AppThemeConfig implements BaseData {
  final String language;
  final String deviceType;
  final String themeType;
  final ColorSchemeModel? colorSchemeLight;
  final ColorSchemeModel? colorSchemeDark;
  final AccessibilitySettings? accessibilityModel;

  AppThemeConfig({
    required this.language,
    required this.themeType,
    required this.deviceType,
    required this.colorSchemeLight,
    required this.colorSchemeDark,
    required this.accessibilityModel
  });



  @override
  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'themeType': themeType,
      'deviceType': deviceType,
      'colorSchemeLight': colorSchemeLight?.toJson(),
      'colorSchemeDark': colorSchemeDark?.toJson(),
      'accessibility': accessibilityModel?.toJson(),
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
      'primary': colorScheme.primary.value,
      'onPrimary': colorScheme.onPrimary.value,
      'secondary': colorScheme.secondary.value,
      'onSecondary': colorScheme.onSecondary.value,
      'error': colorScheme.error.value,
      'onError': colorScheme.onError.value,
      'surface': colorScheme.surface.value,
      'onSurface': colorScheme.onSurface.value,
      'brightness': colorScheme.brightness.name,
      'cardColor': cardColor.value,
      'scaffoldBackgroundColor': scaffoldBackgroundColor.value,
    };
  }
}
