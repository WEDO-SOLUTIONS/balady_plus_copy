import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor;

class DrawFrameWidget extends StatelessWidget {
  final Color? frameColor;
  final double frameWidth;
  final double frameRadius;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  const DrawFrameWidget({
    super.key,
    this.frameColor,
    this.frameWidth = 1.0,
    this.frameRadius = 2.0,
    this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(frameRadius),
        border: Border.all(color: _framColor, width: frameWidth),
      ),
      child: child,
    );
  }

  Color get _framColor => frameColor ?? AppColor.blue;
}
