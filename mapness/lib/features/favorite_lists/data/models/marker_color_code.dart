import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/colorsV2/base_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum MarkerColorCode {
  blue,
  green,
  red,
  orange,
  purple,
  pink,
  yellow,
  teal,
  unknown;

  Color getColor(AppColorsThemeV3 colors) => switch (this) {
    MarkerColorCode.blue => BaseColors.extra03,
    MarkerColorCode.green => BaseColors.success,
    MarkerColorCode.red => BaseColors.error,
    MarkerColorCode.orange => BaseColors.warning,
    MarkerColorCode.purple => BaseColors.extra01,
    MarkerColorCode.pink => BaseColors.accentSecondary,
    MarkerColorCode.yellow => BaseColors.extra02,
    MarkerColorCode.teal => BaseColors.accent,
    MarkerColorCode.unknown => colors.staticBlack,
  };
}
