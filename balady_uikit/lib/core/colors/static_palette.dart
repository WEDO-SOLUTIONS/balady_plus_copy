import 'dart:ui';

abstract class StaticPalette {
  Color get textAndIconsBasePrimary;
  Color get textAndIconsBaseInversePrimary;
  Color get textAndIconsBaseSecondary;
  Color get textAndIconsBaseInverseSecondary;
  Color get textAndIconsBaseInverseTertiary;
  Color get textAndIconsBaseTertiary;
  Color get surfaceContrastLow;
  Color get surfaceContrastMid;
  Color get surfaceContrastHigh;
  Color get surfaceStatusContrastAccent;
  Color get surfaceStatusContrastPositive;
  Color get surfaceContrastInverseLow;
  Color get surfaceStatusContrastAttention;
  Color get surfaceContrastInverseMid;
  Color get surfaceContrastInverseHigh;
  Color get surfaceStatusContrastNegative;
  Color get surfaceStatusNegative;
  Color get surfaceStatusAttention;
  Color get surfaceStatusPositive;
  Color get surfaceStatusAccent;
  Color get surfaceOverlayModal;
  Color get surfaceOverlayPressed;
  Color get surfaceOverlayPressedLight;
  Color get surfaceBasePrimary;
}
