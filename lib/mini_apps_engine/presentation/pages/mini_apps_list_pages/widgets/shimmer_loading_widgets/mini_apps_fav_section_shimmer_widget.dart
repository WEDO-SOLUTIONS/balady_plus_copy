import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//!
class MiniAppsFavSectionShimmerWidget extends StatelessWidget {
  const MiniAppsFavSectionShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium shimmer palette (no pure black)
    final baseColor = isDark ? const Color(0xFF2A2F3A) : const Color(0xFFE7E9EF);
    final highlightColor = isDark ? const Color(0xFF3A4150) : const Color(0xFFF5F6FA);

    // Surfaces
    final surface = isDark ? const Color(0xFF141821) : Colors.white;
    final placeholder = isDark ? const Color(0xFF1D2430) : Colors.white;

    // Subtle borders & shadow for “premium”
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04);

    final shadowColor = isDark ? Colors.black.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.06);

    // Dimensions
    final double iconWidth = context.screenWidth * 0.14;
    final double iconHeight = context.screenWidth * 0.14;
    final double titlesWidth = iconWidth;
    final double titlesHeight = context.h(30);

    Widget buildShimmerItem(BuildContext context, bool isDashedAdd) {
      return Container(
        width: iconWidth,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Column(
          children: [
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                width: iconWidth,
                height: iconHeight,
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDashedAdd
                        ? (isDark ? Colors.white.withValues(alpha: 0.14) : Colors.black.withValues(alpha: 0.08))
                        : borderColor,
                    width: isDashedAdd ? 1.5 : 1,
                  ),
                  boxShadow: [BoxShadow(color: shadowColor, blurRadius: isDark ? 10 : 8, offset: const Offset(0, 6))],
                ),
                child: isDashedAdd
                    ? Center(
                        child: Container(
                          width: iconWidth * 0.46,
                          height: iconHeight * 0.46,
                          decoration: BoxDecoration(
                            color: placeholder,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.black.withValues(alpha: 0.04),
                              width: 1,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ),

            // Text Shimmer
            SizedBox(height: context.h(4)),
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                width: titlesWidth,
                height: titlesHeight * 0.5,
                decoration: BoxDecoration(
                  color: placeholder,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor, width: 1),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title shimmer
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: context.w(170),
            height: context.h(33),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1),
              boxShadow: [BoxShadow(color: shadowColor, blurRadius: isDark ? 10 : 8, offset: const Offset(0, 6))],
            ),
          ),
        ),

        SizedBox(height: context.screenHeight * 0.02),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildShimmerItem(context, true),
            SizedBox(width: context.screenWidth * 0.04),
            Expanded(
              child: SizedBox(
                height: iconHeight + titlesHeight + context.h(20),
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(width: context.screenWidth * 0.03),
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) => buildShimmerItem(context, false),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
