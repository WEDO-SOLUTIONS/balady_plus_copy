import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

class CustomSvgIconWidget extends StatelessWidget {
  final String iconPath;
  final double? iconSize;
  final double? iconWidth;
  final double? iconHeight;
  final Color? iconColor;
  final AlignmentGeometry? iconAlignment;
  final BoxFit? iconFit;

  const CustomSvgIconWidget(
    this.iconPath, {
    super.key,
    this.iconSize,
    this.iconWidth,
    this.iconHeight,
    this.iconColor,
    this.iconAlignment,
    this.iconFit,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      color: iconColor,
      width: iconWidth ?? iconSize,
      height: iconHeight ?? iconSize,
      alignment: iconAlignment ?? Alignment.center,
      fit: iconFit ?? BoxFit.contain,
    );
  }
}
