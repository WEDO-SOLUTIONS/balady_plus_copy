import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor;

class DrawLineWidget extends StatelessWidget {
  final double lineHeight;
  final double? lineWidth;
  final Color? lineColor;
  final double verticalMargin;
  final double horizontalMargin;
  final double radius;
  const DrawLineWidget({
    super.key,
    this.lineHeight = 1.0,
    this.lineWidth,
    this.lineColor,
    this.horizontalMargin = 0.0,
    this.verticalMargin = 0.0,
    this.radius = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: lineWidth ?? double.infinity,
      height: lineHeight,
      decoration: BoxDecoration(
        color: lineColor ?? AppColor.gray,
        borderRadius: BorderRadius.circular(radius),
      ),
      margin: EdgeInsets.symmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
    );
  }
}
