import 'package:balady_uikit/gen/default_color_scheme/dark_default_color_scheme.dart';
import 'package:balady_uikit/gen/default_color_scheme/light_default_color_scheme.dart';
import 'package:balady_uikit/gen/default_color_scheme/static_default_color_scheme.dart';
import 'package:flutter/material.dart';

class AppColorsThemeExt extends ThemeExtension<AppColorsThemeExt> {
  final Color textAndIconsBasePrimary;
  final Color textAndIconsBaseSecondary;
  final Color textAndIconsBaseTertiary;
  final Color textAndIconsBaseInversePrimary;
  final Color textAndIconsBaseInverseSecondary;
  final Color textAndIconsBaseInverseTertiary;
  final Color textAndIconsStatusAccent;
  final Color textAndIconsStatusPositive;
  final Color textAndIconsStatusAttention;
  final Color textAndIconsStatusNegative;
  final Color surfaceBasePrimary;
  final Color surfaceBaseSecondary;
  final Color surfaceBaseTertiary;
  final Color surfaceContrastLow;
  final Color surfaceBaseInversePrimary;
  final Color surfaceContrastMid;
  final Color surfaceContrastHigh;
  final Color strokePrimary;
  final Color strokeAccent;
  final Color strokeNegative;
  final Color surfaceStatusContrastAccent;
  final Color surfaceStatusContrastPositive;
  final Color surfaceContrastInverseLow;
  final Color surfaceStatusContrastAttention;
  final Color surfaceContrastInverseMid;
  final Color surfaceContrastInverseHigh;
  final Color surfaceStatusContrastNegative;
  final Color surfaceStatusNegative;
  final Color surfaceStatusAttention;
  final Color surfaceStatusPositive;
  final Color surfaceStatusAccent;
  final Color surfaceOverlayModal;
  final Color surfaceOverlayPressed;

  AppColorsThemeExt({
    required this.textAndIconsBasePrimary,
    required this.textAndIconsBaseSecondary,
    required this.textAndIconsBaseTertiary,
    required this.textAndIconsBaseInversePrimary,
    required this.textAndIconsBaseInverseSecondary,
    required this.textAndIconsBaseInverseTertiary,
    required this.textAndIconsStatusAccent,
    required this.textAndIconsStatusPositive,
    required this.textAndIconsStatusAttention,
    required this.textAndIconsStatusNegative,
    required this.surfaceBasePrimary,
    required this.surfaceBaseSecondary,
    required this.surfaceBaseTertiary,
    required this.surfaceContrastLow,
    required this.surfaceBaseInversePrimary,
    required this.surfaceContrastMid,
    required this.surfaceContrastHigh,
    required this.strokePrimary,
    required this.strokeAccent,
    required this.strokeNegative,
    required this.surfaceStatusContrastAccent,
    required this.surfaceStatusContrastPositive,
    required this.surfaceContrastInverseLow,
    required this.surfaceStatusContrastAttention,
    required this.surfaceContrastInverseMid,
    required this.surfaceContrastInverseHigh,
    required this.surfaceStatusContrastNegative,
    required this.surfaceStatusNegative,
    required this.surfaceStatusAttention,
    required this.surfaceStatusPositive,
    required this.surfaceStatusAccent,
    required this.surfaceOverlayModal,
    required this.surfaceOverlayPressed,
  });

  @override
  ThemeExtension<AppColorsThemeExt> copyWith({
    Color? textAndIconsBasePrimary,
    Color? textAndIconsBaseSecondary,
    Color? textAndIconsBaseTertiary,
    Color? textAndIconsBaseInversePrimary,
    Color? textAndIconsBaseInverseSecondary,
    Color? textAndIconsBaseInverseTertiary,
    Color? textAndIconsStatusAccent,
    Color? textAndIconsStatusPositive,
    Color? textAndIconsStatusAttention,
    Color? textAndIconsStatusNegative,
    Color? surfaceBasePrimary,
    Color? surfaceBaseSecondary,
    Color? surfaceBaseTertiary,
    Color? surfaceContrastLow,
    Color? surfaceBaseInversePrimary,
    Color? surfaceContrastMid,
    Color? surfaceContrastHigh,
    Color? strokePrimary,
    Color? strokeAccent,
    Color? strokeNegative,
    Color? surfaceStatusContrastAccent,
    Color? surfaceStatusContrastPositive,
    Color? surfaceContrastInverseLow,
    Color? surfaceStatusContrastAttention,
    Color? surfaceContrastInverseMid,
    Color? surfaceContrastInverseHigh,
    Color? surfaceStatusContrastNegative,
    Color? surfaceStatusNegative,
    Color? surfaceStatusAttention,
    Color? surfaceStatusPositive,
    Color? surfaceStatusAccent,
    Color? surfaceOverlayModal,
    Color? surfaceOverlayPressed,
  }) =>
      AppColorsThemeExt(
        textAndIconsBasePrimary: textAndIconsBasePrimary ?? this.textAndIconsBasePrimary,
        textAndIconsBaseSecondary: textAndIconsBaseSecondary ?? this.textAndIconsBaseSecondary,
        textAndIconsBaseTertiary: textAndIconsBaseTertiary ?? this.textAndIconsBaseTertiary,
        textAndIconsBaseInversePrimary: textAndIconsBaseInversePrimary ?? this.textAndIconsBaseInversePrimary,
        textAndIconsBaseInverseSecondary: textAndIconsBaseInverseSecondary ?? this.textAndIconsBaseInverseSecondary,
        textAndIconsBaseInverseTertiary: textAndIconsBaseInverseTertiary ?? this.textAndIconsBaseInverseTertiary,
        textAndIconsStatusAccent: textAndIconsStatusAccent ?? this.textAndIconsStatusAccent,
        textAndIconsStatusPositive: textAndIconsStatusPositive ?? this.textAndIconsStatusPositive,
        textAndIconsStatusAttention: textAndIconsStatusAttention ?? this.textAndIconsStatusAttention,
        textAndIconsStatusNegative: textAndIconsStatusNegative ?? this.textAndIconsStatusNegative,
        surfaceBasePrimary: surfaceBasePrimary ?? this.surfaceBasePrimary,
        surfaceBaseSecondary: surfaceBaseSecondary ?? this.surfaceBaseSecondary,
        surfaceBaseTertiary: surfaceBaseTertiary ?? this.surfaceBaseTertiary,
        surfaceContrastLow: surfaceContrastLow ?? this.surfaceContrastLow,
        surfaceBaseInversePrimary: surfaceBaseInversePrimary ?? this.surfaceBaseInversePrimary,
        surfaceContrastMid: surfaceContrastMid ?? this.surfaceContrastMid,
        surfaceContrastHigh: surfaceContrastHigh ?? this.surfaceContrastHigh,
        strokePrimary: strokePrimary ?? this.strokePrimary,
        strokeAccent: strokeAccent ?? this.strokeAccent,
        strokeNegative: strokeNegative ?? this.strokeNegative,
        surfaceStatusContrastAccent: surfaceStatusContrastAccent ?? this.surfaceStatusContrastAccent,
        surfaceStatusContrastPositive: surfaceStatusContrastPositive ?? this.surfaceStatusContrastPositive,
        surfaceContrastInverseLow: surfaceContrastInverseLow ?? this.surfaceContrastInverseLow,
        surfaceStatusContrastAttention: surfaceStatusContrastAttention ?? this.surfaceStatusContrastAttention,
        surfaceContrastInverseMid: surfaceContrastInverseMid ?? this.surfaceContrastInverseMid,
        surfaceContrastInverseHigh: surfaceContrastInverseHigh ?? this.surfaceContrastInverseHigh,
        surfaceStatusContrastNegative: surfaceStatusContrastNegative ?? this.surfaceStatusContrastNegative,
        surfaceStatusNegative: surfaceStatusNegative ?? this.surfaceStatusNegative,
        surfaceStatusAttention: surfaceStatusAttention ?? this.surfaceStatusAttention,
        surfaceStatusPositive: surfaceStatusPositive ?? this.surfaceStatusPositive,
        surfaceStatusAccent: surfaceStatusAccent ?? this.surfaceStatusAccent,
        surfaceOverlayModal: surfaceOverlayModal ?? this.surfaceOverlayModal,
        surfaceOverlayPressed: surfaceOverlayPressed ?? this.surfaceOverlayPressed,
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
      textAndIconsBasePrimary: Color.lerp(textAndIconsBasePrimary, other.textAndIconsBasePrimary, t)!,
      textAndIconsBaseSecondary: Color.lerp(textAndIconsBaseSecondary, other.textAndIconsBaseSecondary, t)!,
      textAndIconsBaseTertiary: Color.lerp(textAndIconsBaseTertiary, other.textAndIconsBaseTertiary, t)!,
      textAndIconsBaseInversePrimary:
          Color.lerp(textAndIconsBaseInversePrimary, other.textAndIconsBaseInversePrimary, t)!,
      textAndIconsBaseInverseSecondary:
          Color.lerp(textAndIconsBaseInverseSecondary, other.textAndIconsBaseInverseSecondary, t)!,
      textAndIconsBaseInverseTertiary:
          Color.lerp(textAndIconsBaseInverseTertiary, other.textAndIconsBaseInverseTertiary, t)!,
      textAndIconsStatusAccent: Color.lerp(textAndIconsStatusAccent, other.textAndIconsStatusAccent, t)!,
      textAndIconsStatusPositive: Color.lerp(textAndIconsStatusPositive, other.textAndIconsStatusPositive, t)!,
      textAndIconsStatusAttention: Color.lerp(textAndIconsStatusAttention, other.textAndIconsStatusAttention, t)!,
      textAndIconsStatusNegative: Color.lerp(textAndIconsStatusNegative, other.textAndIconsStatusNegative, t)!,
      surfaceBasePrimary: Color.lerp(surfaceBasePrimary, other.surfaceBasePrimary, t)!,
      surfaceBaseSecondary: Color.lerp(surfaceBaseSecondary, other.surfaceBaseSecondary, t)!,
      surfaceBaseTertiary: Color.lerp(surfaceBaseTertiary, other.surfaceBaseTertiary, t)!,
      surfaceContrastLow: Color.lerp(surfaceContrastLow, other.surfaceContrastLow, t)!,
      surfaceBaseInversePrimary: Color.lerp(surfaceBaseInversePrimary, other.surfaceBaseInversePrimary, t)!,
      surfaceContrastMid: Color.lerp(surfaceContrastMid, other.surfaceContrastMid, t)!,
      surfaceContrastHigh: Color.lerp(surfaceContrastHigh, other.surfaceContrastHigh, t)!,
      strokePrimary: Color.lerp(strokePrimary, other.strokePrimary, t)!,
      strokeAccent: Color.lerp(strokeAccent, other.strokeAccent, t)!,

      strokeNegative: Color.lerp(strokeNegative, other.strokeNegative, t)!,
      surfaceStatusContrastAccent: Color.lerp(surfaceStatusContrastAccent, other.surfaceStatusContrastAccent, t)!,
      surfaceStatusContrastPositive: Color.lerp(surfaceStatusContrastPositive, other.surfaceStatusContrastPositive, t)!,
      surfaceContrastInverseLow: Color.lerp(surfaceContrastInverseLow, other.surfaceContrastInverseLow, t)!,
      surfaceStatusContrastAttention:
          Color.lerp(surfaceStatusContrastAttention, other.surfaceStatusContrastAttention, t)!,
      surfaceContrastInverseMid: Color.lerp(surfaceContrastInverseMid, other.surfaceContrastInverseMid, t)!,
      surfaceContrastInverseHigh: Color.lerp(surfaceContrastInverseHigh, other.surfaceContrastInverseHigh, t)!,
      surfaceStatusContrastNegative: Color.lerp(surfaceStatusContrastNegative, other.surfaceStatusContrastNegative, t)!,
      surfaceStatusNegative: Color.lerp(surfaceStatusNegative, other.surfaceStatusNegative, t)!,
      surfaceStatusAttention: Color.lerp(surfaceStatusAttention, other.surfaceStatusAttention, t)!,
      surfaceStatusPositive: Color.lerp(surfaceStatusPositive, other.surfaceStatusPositive, t)!,
      surfaceStatusAccent: Color.lerp(surfaceStatusAccent, other.surfaceStatusAccent, t)!,
      surfaceOverlayModal: Color.lerp(surfaceOverlayModal, other.surfaceOverlayModal, t)!,
      surfaceOverlayPressed: Color.lerp(surfaceOverlayPressed, other.surfaceOverlayPressed, t)!,
    );
  }

  factory AppColorsThemeExt.palette({required bool isDark}) {
    final dark = DarkDefaultColorScheme();
    final light = LightDefaultColorScheme();

    final staticColor = StaticDefaultColorScheme();

    return AppColorsThemeExt(
      textAndIconsBasePrimary: isDark ? dark.textAndIconsBasePrimary : light.textAndIconsBasePrimary,
      textAndIconsBaseSecondary: isDark ? dark.textAndIconsBaseSecondary : light.textAndIconsBaseSecondary,
      textAndIconsBaseTertiary: isDark ? dark.textAndIconsBaseTertiary : light.textAndIconsBaseTertiary,
      textAndIconsBaseInversePrimary:
          isDark ? dark.textAndIconsBaseInversePrimary : light.textAndIconsBaseInversePrimary,
      textAndIconsBaseInverseSecondary:
          isDark ? dark.textAndIconsBaseInverseSecondary : light.textAndIconsBaseInverseSecondary,
      textAndIconsBaseInverseTertiary:
          isDark ? dark.textAndIconsBaseInverseTertiary : light.textAndIconsBaseInverseTertiary,
      textAndIconsStatusAccent: isDark ? dark.textAndIconsStatusAccent : light.textAndIconsStatusAccent,
      textAndIconsStatusPositive: isDark ? dark.textAndIconsStatusPositive : light.textAndIconsStatusPositive,
      textAndIconsStatusAttention: isDark ? dark.textAndIconsStatusAttention : light.textAndIconsStatusAttention,
      textAndIconsStatusNegative: isDark ? dark.textAndIconsStatusNegative : light.textAndIconsStatusNegative,
      surfaceBasePrimary: isDark ? dark.surfaceBasePrimary : light.surfaceBasePrimary,
      surfaceBaseSecondary: isDark ? dark.surfaceBaseSecondary : light.surfaceBaseSecondary,
      surfaceBaseTertiary: isDark ? dark.surfaceBaseTertiary : light.surfaceBaseTertiary,
      surfaceContrastLow: isDark ? dark.surfaceContrastLow : light.surfaceContrastLow,
      surfaceBaseInversePrimary: isDark ? dark.surfaceBaseInversePrimary : light.surfaceBaseInversePrimary,
      surfaceContrastMid: isDark ? dark.surfaceContrastMid : light.surfaceContrastMid,
      surfaceContrastHigh: isDark ? dark.surfaceContrastHigh : light.surfaceContrastHigh,
      strokePrimary: isDark ? dark.strokePrimary : light.strokePrimary,
      strokeAccent: isDark ? dark.strokeAccent : light.strokeAccent,
      strokeNegative: isDark ? dark.strokeNegative : light.strokeNegative,
      surfaceStatusContrastAccent: staticColor.surfaceStatusContrastAccent,
      surfaceStatusContrastPositive: staticColor.surfaceStatusContrastPositive,
      surfaceContrastInverseLow: staticColor.surfaceContrastInverseLow,
      surfaceStatusContrastAttention: staticColor.surfaceStatusContrastAttention,
      surfaceContrastInverseMid: staticColor.surfaceContrastInverseMid,
      surfaceContrastInverseHigh: staticColor.surfaceContrastInverseHigh,
      surfaceStatusContrastNegative: staticColor.surfaceStatusContrastNegative,
      surfaceStatusNegative: staticColor.surfaceStatusNegative,
      surfaceStatusAttention: staticColor.surfaceStatusAttention,
      surfaceStatusPositive: staticColor.surfaceStatusPositive,
      surfaceStatusAccent: staticColor.surfaceStatusAccent,
      surfaceOverlayModal: staticColor.surfaceOverlayModal,
      surfaceOverlayPressed: staticColor.surfaceOverlayPressed,
    );
  }

  Map<String, Color> colorList() {
    return {
      'textAndIconsBasePrimary': textAndIconsBasePrimary,
      'textAndIconsBaseSecondary': textAndIconsBaseSecondary,
      'textAndIconsBaseTertiary': textAndIconsBaseTertiary,
      'textAndIconsBaseInversePrimary': textAndIconsBaseInversePrimary,
      'textAndIconsBaseInverseSecondary': textAndIconsBaseInverseSecondary,
      'textAndIconsBaseInverseTertiary': textAndIconsBaseInverseTertiary,
      'textAndIconsStatusAccent': textAndIconsStatusAccent,
      'textAndIconsStatusPositive': textAndIconsStatusPositive,
      'textAndIconsStatusAttention': textAndIconsStatusAttention,
      'textAndIconsStatusNegative': textAndIconsStatusNegative,
      'surfaceBasePrimary': surfaceBasePrimary,
      'surfaceBaseSecondary': surfaceBaseSecondary,
      'surfaceBaseTertiary': surfaceBaseTertiary,
      'surfaceContrastLow': surfaceContrastLow,
      'surfaceBaseInversePrimary': surfaceBaseInversePrimary,
      'surfaceContrastMid': surfaceContrastMid,
      'surfaceContrastHigh': surfaceContrastHigh,
      'strokePrimary': strokePrimary,
      'strokeAccent': strokeAccent,
      'strokeNegative': strokeNegative,
      'surfaceStatusContrastAccent': surfaceStatusContrastAccent,
      'surfaceStatusContrastPositive': surfaceStatusContrastPositive,
      'surfaceContrastInverseLow': surfaceContrastInverseLow,
      'surfaceStatusContrastAttention': surfaceStatusContrastAttention,
      'surfaceContrastInverseMid': surfaceContrastInverseMid,
      'surfaceContrastInverseHigh': surfaceContrastInverseHigh,
      'surfaceStatusContrastNegative': surfaceStatusContrastNegative,
      'surfaceStatusNegative': surfaceStatusNegative,
      'surfaceStatusAttention': surfaceStatusAttention,
      'surfaceStatusPositive': surfaceStatusPositive,
      'surfaceStatusAccent': surfaceStatusAccent,
      'surfaceOverlayModal': surfaceOverlayModal,
      'surfaceOverlayPressed': surfaceOverlayPressed,
    };
  }
}
