import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColorsTheme;

class CustomBoxWidget extends StatelessWidget {
  final double width;
  final double activeWidth;
  final double height;
  final double radius;
  final Color? color;
  final Color? activeColor;
  final Color? inActiveColor;
  final bool isActive;
  final EdgeInsetsGeometry? margin;
  final double horizontalMargin;
  final double verticalMargin;

  const CustomBoxWidget({
    Key? key,
    this.width = 8.0,
    this.activeWidth = 32,
    this.height = 6.0,
    this.radius = 4.0,
    this.color,
    this.activeColor,
    this.inActiveColor,
    this.isActive = true,
    this.margin,
    this.horizontalMargin = 0.0,
    this.verticalMargin = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isActive ? activeWidth : width,
      height: height,
      margin: margin ??
          EdgeInsets.symmetric(
            horizontal: horizontalMargin,
            vertical: verticalMargin,
          ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: isActive
            ? color ?? activeColor ?? AppColorsTheme.primary700
            : inActiveColor ?? AppColorsTheme.primary100,
      ),
    );
  }
}
