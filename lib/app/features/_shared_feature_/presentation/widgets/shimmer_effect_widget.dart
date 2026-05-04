import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' show Shimmer;

import '../../../../core/utils/utils_exports.dart' show ContextConversion;

class ShimmerEffectWidget extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  const ShimmerEffectWidget({
    super.key,
    this.height = 200.0,
    this.width,
    this.borderRadius = 16.0,
    this.margin,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.screenWidth * 0.9,
      height: height,
      child: Shimmer.fromColors(
        baseColor: context.colors.backgroundSurface1,
        highlightColor: context.colors.backgroundSurface1,
        child: Card(
          margin: margin,
          elevation: elevation,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        ),
      ),
    );
  }
}
