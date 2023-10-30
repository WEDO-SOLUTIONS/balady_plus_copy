import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' show Shimmer;

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
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
