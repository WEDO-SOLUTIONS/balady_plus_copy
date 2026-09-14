import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//!
class AnotherAppsGroupShimmerWidget extends StatelessWidget {
  const AnotherAppsGroupShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium shimmer palette (no pure black)
    final baseColor = isDark ? const Color(0xFF2A2F3A) : const Color(0xFFE7E9EF);
    final highlightColor = isDark ? const Color(0xFF3A4150) : const Color(0xFFF5F6FA);

    // Surfaces
    final surface = isDark ? const Color(0xFF141821) : Colors.white;
    final placeholder = isDark ? const Color(0xFF1D2430) : Colors.white;

    // Inner "sub-card" shade (slightly different)
    final subSurface = isDark ? const Color(0xFF202838) : Colors.white.withValues(alpha: 0.55);

    // Subtle borders & shadow for premium feel
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04);

    final shadowColor = isDark ? Colors.black.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.06);

    // CustomLargMoreApps default dimensions:
    final double cardOuterWidth = context.w(168);
    final double cardOuterHeight = context.h(168);
    final double textContainerWidth = context.screenWidth * 0.20;
    final double textContainerHeight = context.screenHeight * 0.04;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main card shimmer
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: cardOuterWidth,
            height: cardOuterHeight,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1),
              boxShadow: [BoxShadow(color: shadowColor, blurRadius: isDark ? 10 : 8, offset: const Offset(0, 6))],
            ),
            child: Padding(
              padding: EdgeInsets.all(context.w(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _AnotherAppsSubCardBox(
                        width: cardOuterWidth * 0.35,
                        height: cardOuterHeight * 0.35,
                        color: subSurface,
                        borderColor: borderColor,
                        radius: 10,
                      ),
                      _AnotherAppsSubCardBox(
                        width: cardOuterWidth * 0.35,
                        height: cardOuterHeight * 0.35,
                        color: subSurface,
                        borderColor: borderColor,
                        radius: 10,
                      ),
                    ],
                  ),
                  SizedBox(height: context.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _AnotherAppsSubCardBox(
                        width: cardOuterWidth * 0.35,
                        height: cardOuterHeight * 0.35,
                        color: subSurface,
                        borderColor: borderColor,
                        radius: 10,
                      ),
                      _AnotherAppsSubCardBox(
                        width: cardOuterWidth * 0.35,
                        height: cardOuterHeight * 0.35,
                        color: subSurface,
                        borderColor: borderColor,
                        radius: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Text container shimmer (below the main card)
        SizedBox(height: context.h(8)),
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: textContainerWidth,
            height: textContainerHeight,
            decoration: BoxDecoration(
              color: placeholder,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1),
              boxShadow: [BoxShadow(color: shadowColor, blurRadius: isDark ? 10 : 8, offset: const Offset(0, 6))],
            ),
          ),
        ),
      ],
    );
  }
}

class _AnotherAppsSubCardBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color color;
  final Color borderColor;

  const _AnotherAppsSubCardBox({
    required this.width,
    required this.height,
    required this.color,
    required this.borderColor,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
          width: 1,
        ),
      ),
    );
  }
}
