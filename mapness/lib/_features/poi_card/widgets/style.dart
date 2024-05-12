import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

const colorShadow = NonThemeColor.color71;
const colorIconPositive = NonThemeColor.color3;
const colorIconError = NonThemeColor.color1;

const headerHeight = 124.0;
const footerHeight = 50.0;
const gapHeight = 16.0;

class StyleText extends StatelessWidget {
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String? text;
  final int maxLines;
  const StyleText({
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    super.key,
    this.text,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return const SizedBox.shrink();
    }
    return Text(
      text!,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: 'Frutiger',
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: TextAlign.start,
    );
  }
}

const borderRadius = BorderRadius.all(
  Radius.circular(8),
);

SvgPicture timeIcon(Color color) => SvgPicture.asset(
      'assets/icons/svg/ic_time.svg',
      package: PackageConfig.packageName,
      height: 24,
      width: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );

SvgPicture parkingIcon = SvgPicture.asset(
  'assets/icons/svg/ic_parking_poi.svg',
  height: 24,
  width: 24,
  package: PackageConfig.packageName,
);
