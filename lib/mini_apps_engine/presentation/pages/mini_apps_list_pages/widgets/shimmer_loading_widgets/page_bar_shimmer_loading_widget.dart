import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//!
class PageBarShimmerLoadingWidget extends StatelessWidget {
  const PageBarShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium shimmer palette (no pure black)
    final baseColor = isDark ? const Color(0xFF2A2F3A) : const Color(0xFFE7E9EF);
    final highlightColor = isDark ? const Color(0xFF3A4150) : const Color(0xFFF5F6FA);

    // Placeholder surface
    final boxColor = isDark ? const Color(0xFF1D2430) : Colors.white;

    // Optional subtle border for a premium feel
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.00),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(
                  width: context.w(120),
                  height: context.h(24),
                  radius: 8,
                  color: boxColor,
                  borderColor: borderColor,
                ),
                SizedBox(height: context.h(6)),
                _ShimmerBox(
                  width: context.w(90),
                  height: context.h(20),
                  radius: 6,
                  color: boxColor,
                  borderColor: borderColor,
                ),
              ],
            ),
            _ShimmerBox(
              width: context.w(50),
              height: context.h(50),
              radius: 25, // Circular avatar
              color: boxColor,
              borderColor: borderColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  final Color color;
  final Color borderColor;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 10,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: 1),
      ),
    );
  }
}
