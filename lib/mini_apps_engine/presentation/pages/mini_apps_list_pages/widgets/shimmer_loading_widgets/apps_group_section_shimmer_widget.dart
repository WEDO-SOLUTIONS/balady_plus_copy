import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//!
class AppsGroupSectionShimmerWidget extends StatelessWidget {
  const AppsGroupSectionShimmerWidget({super.key});

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
    final subSurface = isDark ? const Color(0xFF202838) : Colors.white.withOpacity(0.55);

    // Subtle borders & shadow for premium feel
    final borderColor = isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04);

    final shadowColor = isDark ? Colors.black.withOpacity(0.35) : Colors.black.withOpacity(0.06);

    // GridView specific dimensions:
    const int itemCount = 6;

    // CustomLargMoreApps default dimensions:
    final double cardOuterWidth = double.infinity;
    final double cardOuterHeight = context.h(98);
    final double textContainerWidth = context.screenWidth * 0.20;
    final double textContainerHeight = context.screenHeight * 0.03;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Title Shimmer
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: context.w(150),
            height: context.h(30),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1),
              boxShadow: [BoxShadow(color: shadowColor, blurRadius: isDark ? 10 : 8, offset: const Offset(0, 6))],
            ),
          ),
        ),
        SizedBox(height: context.screenHeight * 0.01),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: context.h(98),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
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
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor, width: 1),
                      boxShadow: [
                        BoxShadow(color: shadowColor, blurRadius: isDark ? 10 : 8, offset: const Offset(0, 6)),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(context.w(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _SubCardShimmerBox(
                                width: context.w(32),
                                height: context.h(32),
                                color: subSurface,
                                borderColor: borderColor,
                                radius: 8,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Text container shimmer
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
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SubCardShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color color;
  final Color borderColor;

  const _SubCardShimmerBox({
    required this.width,
    required this.height,
    required this.color,
    required this.borderColor,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: Colors.white.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.06 : 0.04),
          width: 1,
        ),
      ),
    );
  }
}
