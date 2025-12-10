import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PageBarShimmerLoadingWidget extends StatelessWidget {
  const PageBarShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double w(double v) => v;
    double h(double v) => v;

    return Shimmer.fromColors(
      baseColor: const Color(0xFFE6E9EF),
      highlightColor: const Color(0xFFF5F7FA),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left titles shimmer
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _ShimmerBox(
                width: w(135),
                height: h(30),
                radius: 8,
              ),
              const SizedBox(height: 6),
              _ShimmerBox(
                width: w(120),
                height: h(30),
                radius: 8,
              ),
            ],
          ),

          // Right search field shimmer
          _ShimmerBox(
            width: w(150),
            height: h(48),
            radius: 12,
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
