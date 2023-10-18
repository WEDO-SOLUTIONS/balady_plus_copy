import 'package:flutter/material.dart';
import '../../../../core/utils/utils_exports.dart' show AppColor;

class GlowingScrollWidget extends StatelessWidget {
  final AxisDirection? axisDirection;
  final Color? glowingColor;
  final Widget child;
  const GlowingScrollWidget({
    super.key,
    this.axisDirection,
    this.glowingColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: axisDirection ?? AxisDirection.down,
        color: glowingColor ?? AppColor.blue,
        child: child,
      ),
    );
  }
}
