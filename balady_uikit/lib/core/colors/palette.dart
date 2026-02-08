import 'dart:ui';

abstract class Palette {
  Color get textAndIconsBasePrimary;
  Color get textAndIconsBaseSecondary;
  Color get textAndIconsBaseTertiary;
  Color get textAndIconsBaseInversePrimary;
  Color get textAndIconsBaseInverseSecondary;
  Color get textAndIconsBaseInverseTertiary;
  Color get textAndIconsStatusAccent;
  Color get textAndIconsStatusPositive;
  Color get textAndIconsStatusAttention;
  Color get textAndIconsStatusNegative;
  Color get surfaceBasePrimary;
  Color get surfaceBaseSecondary;
  Color get surfaceBaseTertiary;
  Color get surfaceContrastLow;
  Color get surfaceBaseInversePrimary;
  Color get surfaceContrastMid;
  Color get surfaceContrastHigh;
  Color get strokePrimary;
  Color get strokeAccent;
  Color get strokeNegative;
}
