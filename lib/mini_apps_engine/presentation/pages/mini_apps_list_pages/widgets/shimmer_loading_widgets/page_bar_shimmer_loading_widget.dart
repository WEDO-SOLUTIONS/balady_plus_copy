import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PageBarShimmerLoadingWidget extends StatelessWidget {
  const PageBarShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double w(double v) => v;
    double h(double v) => v;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium shimmer palette (no pure black)
    final baseColor = isDark
        ? const Color(0xFF2A2F3A)
        : const Color(0xFFE6E9EF);
    final highlightColor = isDark
        ? const Color(0xFF3A4150)
        : const Color(0xFFF5F7FA);

    // Placeholder surface
    final boxColor = isDark ? const Color(0xFF1D2430) : Colors.white;

    // Optional subtle border for a premium feel
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.04);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(
                  width: w(140),
                  height: h(30),
                  radius: 8,
                  color: boxColor,
                  borderColor: borderColor,
                ),
                const SizedBox(height: 6),
                _ShimmerBox(
                  width: w(135),
                  height: h(30),
                  radius: 8,
                  color: boxColor,
                  borderColor: borderColor,
                ),
              ],
            ),
            _ShimmerBox(
              width: w(150),
              height: h(48),
              radius: 12,
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
