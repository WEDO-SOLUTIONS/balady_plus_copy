import 'package:balady_uikit/core/icons/app_icons.dart';
import 'package:flutter/cupertino.dart';

extension IconDataExt on IconData {
  AppIcons icon({double? size = 24, Color? color}) => AppIcons(
        size: size,
        iconData: this,
        color: color,
      );
}
