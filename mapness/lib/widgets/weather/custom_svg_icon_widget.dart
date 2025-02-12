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
  Widget build(BuildContext context) => SvgPicture.asset(
        iconPath,
        colorFilter: iconColor == null
            ? null
            : ColorFilter.mode(
                iconColor!,
                BlendMode.srcIn,
              ),
        width: iconWidth ?? iconSize,
        height: iconHeight ?? iconSize,
        alignment: iconAlignment ?? Alignment.center,
        fit: iconFit ?? BoxFit.contain,
      );
}

class CustomSvgIconWithBackgroundWidget extends StatelessWidget {
  final String iconPath;
  final double iconWidth;
  final double iconHeight;
  final Color? iconColor;
  final Alignment iconAlignment;
  final BoxFit iconFit;
  final double width;
  final double height;
  final Color? backgroundColor;
  final BoxShape backgroundShape;

  const CustomSvgIconWithBackgroundWidget(
    this.iconPath, {
    super.key,
    this.iconWidth = 16,
    this.iconHeight = 16,
    this.iconColor,
    this.iconAlignment = Alignment.center,
    this.iconFit = BoxFit.none,
    this.backgroundColor,
    this.width = 60.0,
    this.height = 60.0,
    this.backgroundShape = BoxShape.circle,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: backgroundShape,
          // color: backgroundColor ?? AppColors.black200.withOpacity(0.3),
          color: backgroundColor ?? Colors.white60,
        ),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: iconColor == null
              ? null
              : ColorFilter.mode(
                  iconColor!,
                  BlendMode.srcIn,
                ),
          width: iconWidth,
          height: iconHeight,
          alignment: iconAlignment,
          fit: iconFit,
        ),
      );
}
