import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class CustomBoxWidget extends StatelessWidget {
  final double size;
  final double radius;
  final Color? color;
  final Color activeColor;
  final Color inActiveColor;
  final bool isActive;
  final EdgeInsetsGeometry? margin;
  final double horizontalMargin;
  final double verticalMargin;
  const CustomBoxWidget({
    super.key,
    this.size = 6.0,
    this.radius = 1.0,
    this.color,
    this.activeColor = AppColor.greenishYellow500,
    this.inActiveColor = AppColor.black200,
    this.isActive = true,
    this.margin,
    this.horizontalMargin = 0.0,
    this.verticalMargin = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin ??
          EdgeInsets.symmetric(
            horizontal: horizontalMargin,
            vertical: verticalMargin,
          ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: isActive ? color ?? activeColor : inActiveColor,
      ),
    );
  }
}
