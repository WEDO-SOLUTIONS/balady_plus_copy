import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/gen/default_color_scheme/static_default_color_scheme.dart';
import 'package:flutter/material.dart';

@Deprecated("We don't have to use static colors anymore, use colors from AppColorsThemeV3 instead.")
class AppStaticColorsThemeExt extends ThemeExtension<AppStaticColorsThemeExt> {
  final Color textAndIconsBasePrimary;
  final Color textAndIconsBaseSecondary;
  final Color textAndIconsBaseTertiary;
  final Color textAndIconsBaseInversePrimary;
  final Color textAndIconsBaseInverseSecondary;
  final Color textAndIconsBaseInverseTertiary;
  final Color surfaceContrastLow;
  final Color surfaceContrastMid;
  final Color surfaceContrastHigh;
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
  final Color surfaceOverlayPressedLight;
  final Color surfaceBasePrimary;

  AppStaticColorsThemeExt({
    required this.textAndIconsBasePrimary,
    required this.textAndIconsBaseSecondary,
    required this.textAndIconsBaseTertiary,
    required this.textAndIconsBaseInversePrimary,
    required this.textAndIconsBaseInverseSecondary,
    required this.textAndIconsBaseInverseTertiary,
    required this.surfaceContrastLow,
    required this.surfaceContrastMid,
    required this.surfaceContrastHigh,
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
    required this.surfaceOverlayPressedLight,
    required this.surfaceBasePrimary,
  });

  @override
  ThemeExtension<AppStaticColorsThemeExt> copyWith({
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
    Color? surfaceOverlayPressedLight,
  }) =>
      AppStaticColorsThemeExt(
        surfaceOverlayPressedLight: surfaceOverlayPressedLight ?? this.surfaceOverlayPressedLight,
        textAndIconsBasePrimary: textAndIconsBasePrimary ?? this.textAndIconsBasePrimary,
        surfaceBasePrimary: surfaceBasePrimary ?? this.surfaceBasePrimary,
        textAndIconsBaseSecondary: textAndIconsBaseSecondary ?? this.textAndIconsBaseSecondary,
        textAndIconsBaseTertiary: textAndIconsBaseTertiary ?? this.textAndIconsBaseTertiary,
        textAndIconsBaseInversePrimary: textAndIconsBaseInversePrimary ?? this.textAndIconsBaseInversePrimary,
        textAndIconsBaseInverseSecondary: textAndIconsBaseInverseSecondary ?? this.textAndIconsBaseInverseSecondary,
        textAndIconsBaseInverseTertiary: textAndIconsBaseInverseTertiary ?? this.textAndIconsBaseInverseTertiary,
        surfaceContrastLow: surfaceContrastLow ?? this.surfaceContrastLow,
        surfaceContrastMid: surfaceContrastMid ?? this.surfaceContrastMid,
        surfaceContrastHigh: surfaceContrastHigh ?? this.surfaceContrastHigh,
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
  ThemeExtension<AppStaticColorsThemeExt> lerp(
    AppStaticColorsThemeExt other,
    double t,
  ) {
    if (other is! AppColorsThemeExt) {
      return this;
    }

    return AppStaticColorsThemeExt(
      surfaceOverlayPressedLight: Color.lerp(surfaceOverlayPressedLight, surfaceOverlayPressedLight, t)!,
      surfaceBasePrimary: Color.lerp(surfaceBasePrimary, other.surfaceBasePrimary, t)!,
      textAndIconsBasePrimary: Color.lerp(textAndIconsBasePrimary, other.textAndIconsBasePrimary, t)!,
      textAndIconsBaseSecondary: Color.lerp(textAndIconsBaseSecondary, other.textAndIconsBaseSecondary, t)!,
      textAndIconsBaseTertiary: Color.lerp(textAndIconsBaseTertiary, other.textAndIconsBaseTertiary, t)!,
      textAndIconsBaseInversePrimary:
          Color.lerp(textAndIconsBaseInversePrimary, other.textAndIconsBaseInversePrimary, t)!,
      textAndIconsBaseInverseSecondary:
          Color.lerp(textAndIconsBaseInverseSecondary, other.textAndIconsBaseInverseSecondary, t)!,
      textAndIconsBaseInverseTertiary:
          Color.lerp(textAndIconsBaseInverseTertiary, other.textAndIconsBaseInverseTertiary, t)!,
      surfaceContrastLow: Color.lerp(surfaceContrastLow, other.surfaceContrastLow, t)!,
      surfaceContrastMid: Color.lerp(surfaceContrastMid, other.surfaceContrastMid, t)!,
      surfaceContrastHigh: Color.lerp(surfaceContrastHigh, other.surfaceContrastHigh, t)!,
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

  factory AppStaticColorsThemeExt.palette() {
    final staticColor = StaticDefaultColorScheme();

    return AppStaticColorsThemeExt(
      surfaceOverlayPressedLight: staticColor.surfaceOverlayPressedLight,
      surfaceBasePrimary: staticColor.surfaceBasePrimary,
      textAndIconsBasePrimary: staticColor.textAndIconsBasePrimary,
      textAndIconsBaseSecondary: staticColor.textAndIconsBaseSecondary,
      textAndIconsBaseTertiary: staticColor.textAndIconsBaseTertiary,
      textAndIconsBaseInversePrimary: staticColor.textAndIconsBaseInversePrimary,
      textAndIconsBaseInverseSecondary: staticColor.textAndIconsBaseInverseSecondary,
      textAndIconsBaseInverseTertiary: staticColor.textAndIconsBaseInverseTertiary,
      surfaceContrastLow: staticColor.surfaceContrastLow,
      surfaceContrastMid: staticColor.surfaceContrastMid,
      surfaceContrastHigh: staticColor.surfaceContrastHigh,
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
      'surfaceContrastLow': surfaceContrastLow,
      'surfaceContrastMid': surfaceContrastMid,
      'surfaceContrastHigh': surfaceContrastHigh,
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
      'surfaceOverlayPressedLight': surfaceOverlayPressedLight,
      'surfaceBasePrimary': surfaceBasePrimary,
    };
  }
}
