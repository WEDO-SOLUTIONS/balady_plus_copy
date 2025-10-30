import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor;

class DrawLineWidget extends StatelessWidget {
  final double lineHeight;
  final double lineWidth;
  final Color lineColor;
  final double verticalMargin;
  final double horizontalMargin;
  final double radius;
  const DrawLineWidget({
    Key? key,
    this.lineHeight = 1.0,
    this.lineWidth = double.infinity,
    this.lineColor = AppColor.dividerColor,
    this.horizontalMargin = 0.0,
    this.verticalMargin = 0.0,
    this.radius = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: lineWidth,
      height: lineHeight,
      decoration: BoxDecoration(
        color: lineColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      margin: EdgeInsets.symmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
    );
  }
}
