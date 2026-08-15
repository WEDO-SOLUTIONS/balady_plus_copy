import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/colorsV2/base_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum MarkerColorCode {
  orange,
  red,
  blue,
  purple,
  unknown;

  Color getColor(AppColorsThemeV3 colors) => switch (this) {
    MarkerColorCode.orange => BaseColors.warning,
    MarkerColorCode.red => BaseColors.error,
    MarkerColorCode.blue => BaseColors.extra03,
    MarkerColorCode.purple => BaseColors.extra01,
    MarkerColorCode.unknown => colors.staticBlack,
  };
}
