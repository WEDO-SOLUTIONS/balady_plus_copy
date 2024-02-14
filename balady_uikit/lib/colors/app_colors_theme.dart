import 'package:balady_uikit/gen/dark.dart';
import 'package:balady_uikit/gen/light.dart';
import 'package:flutter/material.dart';

class AppColorsThemeExt extends ThemeExtension<AppColorsThemeExt> {
  Color text_and_icons_base_primary;
  Color text_and_icons_base_secondary;
  Color text_and_icons_base_tertiary;
  Color text_and_icons_base_inverse_primary;
  Color text_and_icons_base_inverse_secondary;
  Color text_and_icons_base_inverse_tertiary;
  Color text_and_icons_status_accent;
  Color text_and_icons_status_positive;
  Color text_and_icons_status_attention;
  Color text_and_icons_status_negative;
  Color surface_base_primary;
  Color surface_base_secondary;
  Color surface_base_tertiary;
  Color surface_contrast_low;
  Color surface_base_inverse_primary;
  Color surface_contrast_mid;
  Color surface_contrast_high;
  Color stroke_primary;
  Color stroke_accent;

  AppColorsThemeExt({
    required this.text_and_icons_base_primary,
    required this.text_and_icons_base_secondary,
    required this.text_and_icons_base_tertiary,
    required this.text_and_icons_base_inverse_primary,
    required this.text_and_icons_base_inverse_secondary,
    required this.text_and_icons_base_inverse_tertiary,
    required this.text_and_icons_status_accent,
    required this.text_and_icons_status_positive,
    required this.text_and_icons_status_attention,
    required this.text_and_icons_status_negative,
    required this.surface_base_primary,
    required this.surface_base_secondary,
    required this.surface_base_tertiary,
    required this.surface_contrast_low,
    required this.surface_base_inverse_primary,
    required this.surface_contrast_mid,
    required this.surface_contrast_high,
    required this.stroke_primary,
    required this.stroke_accent,
  });

  @override
  ThemeExtension<AppColorsThemeExt> copyWith({
    Color? text_and_icons_base_primary,
    Color? text_and_icons_base_secondary,
    Color? text_and_icons_base_tertiary,
    Color? text_and_icons_base_inverse_primary,
    Color? text_and_icons_base_inverse_secondary,
    Color? text_and_icons_base_inverse_tertiary,
    Color? text_and_icons_status_accent,
    Color? text_and_icons_status_positive,
    Color? text_and_icons_status_attention,
    Color? text_and_icons_status_negative,
    Color? surface_base_primary,
    Color? surface_base_secondary,
    Color? surface_base_tertiary,
    Color? surface_contrast_low,
    Color? surface_base_inverse_primary,
    Color? surface_contrast_mid,
    Color? surface_contrast_high,
    Color? stroke_primary,
    Color? stroke_accent,
  }) => AppColorsThemeExt(
      text_and_icons_base_primary:
          text_and_icons_base_primary ?? this.text_and_icons_base_primary,
      text_and_icons_base_secondary:
          text_and_icons_base_secondary ?? this.text_and_icons_base_secondary,
      text_and_icons_base_tertiary:
          text_and_icons_base_tertiary ?? this.text_and_icons_base_tertiary,
      text_and_icons_base_inverse_primary:
          text_and_icons_base_inverse_primary ??
              this.text_and_icons_base_inverse_primary,
      text_and_icons_base_inverse_secondary:
          text_and_icons_base_inverse_secondary ??
              this.text_and_icons_base_inverse_secondary,
      text_and_icons_base_inverse_tertiary:
          text_and_icons_base_inverse_tertiary ??
              this.text_and_icons_base_inverse_tertiary,
      text_and_icons_status_accent:
          text_and_icons_status_accent ?? this.text_and_icons_status_accent,
      text_and_icons_status_positive:
          text_and_icons_status_positive ?? this.text_and_icons_status_positive,
      text_and_icons_status_attention: text_and_icons_status_attention ??
          this.text_and_icons_status_attention,
      text_and_icons_status_negative:
          text_and_icons_status_negative ?? this.text_and_icons_status_negative,
      surface_base_primary: surface_base_primary ?? this.surface_base_primary,
      surface_base_secondary:
          surface_base_secondary ?? this.surface_base_secondary,
      surface_base_tertiary:
          surface_base_tertiary ?? this.surface_base_tertiary,
      surface_contrast_low: surface_contrast_low ?? this.surface_contrast_low,
      surface_base_inverse_primary:
          surface_base_inverse_primary ?? this.surface_base_inverse_primary,
      surface_contrast_mid: surface_contrast_mid ?? this.surface_contrast_mid,
      surface_contrast_high:
          surface_contrast_high ?? this.surface_contrast_high,
      stroke_primary: stroke_primary ?? this.stroke_primary,
      stroke_accent: stroke_accent ?? this.stroke_accent,
    );

  @override
  ThemeExtension<AppColorsThemeExt> lerp(
    ThemeExtension<AppColorsThemeExt>? other,
    double t,
  ) {
    if (other is! AppColorsThemeExt) {
      return this;
    }

    return AppColorsThemeExt(
      // headingXL: TextStyle.lerp(headingXL, other.headingXL, t)!,

      text_and_icons_base_primary: Color.lerp(
          text_and_icons_base_primary, other.text_and_icons_base_primary, t)!,
      text_and_icons_base_secondary: Color.lerp(text_and_icons_base_secondary,
          other.text_and_icons_base_secondary, t)!,
      text_and_icons_base_tertiary: Color.lerp(
          text_and_icons_base_tertiary, other.text_and_icons_base_tertiary, t)!,
      text_and_icons_base_inverse_primary: Color.lerp(
          text_and_icons_base_inverse_primary,
          other.text_and_icons_base_inverse_primary,
          t)!,
      text_and_icons_base_inverse_secondary: Color.lerp(
          text_and_icons_base_inverse_secondary,
          other.text_and_icons_base_inverse_secondary,
          t)!,
      text_and_icons_base_inverse_tertiary: Color.lerp(
          text_and_icons_base_inverse_tertiary,
          other.text_and_icons_base_inverse_tertiary,
          t)!,
      text_and_icons_status_accent: Color.lerp(
          text_and_icons_status_accent, other.text_and_icons_status_accent, t)!,
      text_and_icons_status_positive: Color.lerp(text_and_icons_status_positive,
          other.text_and_icons_status_positive, t)!,
      text_and_icons_status_attention: Color.lerp(
          text_and_icons_status_attention,
          other.text_and_icons_status_attention,
          t)!,
      text_and_icons_status_negative: Color.lerp(text_and_icons_status_negative,
          other.text_and_icons_status_negative, t)!,
      surface_base_primary:
          Color.lerp(surface_base_primary, other.surface_base_primary, t)!,
      surface_base_secondary:
          Color.lerp(surface_base_secondary, other.surface_base_secondary, t)!,
      surface_base_tertiary:
          Color.lerp(surface_base_tertiary, other.surface_base_tertiary, t)!,
      surface_contrast_low:
          Color.lerp(surface_contrast_low, other.surface_contrast_low, t)!,
      surface_base_inverse_primary: Color.lerp(
          surface_base_inverse_primary, other.surface_base_inverse_primary, t)!,
      surface_contrast_mid:
          Color.lerp(surface_contrast_mid, other.surface_contrast_mid, t)!,
      surface_contrast_high:
          Color.lerp(surface_contrast_high, other.surface_contrast_high, t)!,
      stroke_primary: Color.lerp(stroke_primary, other.stroke_primary, t)!,
      stroke_accent: Color.lerp(stroke_accent, other.stroke_accent, t)!,
    );
  }

  static palette({required bool isDark}) => AppColorsThemeExt(
        text_and_icons_base_primary: isDark
            ? Dark.text_and_icons_base_primary
            : Light.text_and_icons_base_primary,
        text_and_icons_base_secondary: isDark
            ? Dark.text_and_icons_base_secondary
            : Light.text_and_icons_base_secondary,
        text_and_icons_base_tertiary: isDark
            ? Dark.text_and_icons_base_tertiary
            : Light.text_and_icons_base_tertiary,
        text_and_icons_base_inverse_primary: isDark
            ? Dark.text_and_icons_base_inverse_primary
            : Light.text_and_icons_base_inverse_primary,
        text_and_icons_base_inverse_secondary: isDark
            ? Dark.text_and_icons_base_inverse_secondary
            : Light.text_and_icons_base_inverse_secondary,
        text_and_icons_base_inverse_tertiary: isDark
            ? Dark.text_and_icons_base_inverse_tertiary
            : Light.text_and_icons_base_inverse_tertiary,
        text_and_icons_status_accent: isDark
            ? Dark.text_and_icons_status_accent
            : Light.text_and_icons_status_accent,
        text_and_icons_status_positive: isDark
            ? Dark.text_and_icons_status_positive
            : Light.text_and_icons_status_positive,
        text_and_icons_status_attention: isDark
            ? Dark.text_and_icons_status_attention
            : Light.text_and_icons_status_attention,
        text_and_icons_status_negative: isDark
            ? Dark.text_and_icons_status_negative
            : Light.text_and_icons_status_negative,
        surface_base_primary:
            isDark ? Dark.surface_base_primary : Light.surface_base_primary,
        surface_base_secondary:
            isDark ? Dark.surface_base_secondary : Light.surface_base_secondary,
        surface_base_tertiary:
            isDark ? Dark.surface_base_tertiary : Light.surface_base_tertiary,
        surface_contrast_low:
            isDark ? Dark.surface_contrast_low : Light.surface_contrast_low,
        surface_base_inverse_primary: isDark
            ? Dark.surface_base_inverse_primary
            : Light.surface_base_inverse_primary,
        surface_contrast_mid:
            isDark ? Dark.surface_contrast_mid : Light.surface_contrast_mid,
        surface_contrast_high:
            isDark ? Dark.surface_contrast_high : Light.surface_contrast_high,
        stroke_primary: isDark ? Dark.stroke_primary : Light.stroke_primary,
        stroke_accent: isDark ? Dark.stroke_accent : Light.stroke_accent,
      );
}
