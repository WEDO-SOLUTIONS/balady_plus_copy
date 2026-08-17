import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/colorsV2/base_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

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

  String get favoritePinIconPath => switch (this) {
    // todo(claude): remove these icons and get from FavoriteIconCode
    MarkerColorCode.blue => Assets.icons.svg.layers.icFavPinBlue.keyName,
    MarkerColorCode.green => Assets.icons.svg.layers.icFavPinGreen.keyName,
    MarkerColorCode.red => Assets.icons.svg.layers.icFavPinRed.keyName,
    MarkerColorCode.orange => Assets.icons.svg.layers.icFavPinOrange.keyName,
    MarkerColorCode.purple => Assets.icons.svg.layers.icFavPinPurple.keyName,
    MarkerColorCode.pink => Assets.icons.svg.layers.icFavPinPink.keyName,
    MarkerColorCode.yellow => Assets.icons.svg.layers.icFavPinYellow.keyName,
    MarkerColorCode.teal => Assets.icons.svg.layers.icFavPinTeal.keyName,
    MarkerColorCode.unknown => Assets.icons.svg.layers.icFavPin.keyName,
  };
}
