import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//!
class MiniAppsMostUsedSectionShimmerWidget extends StatelessWidget {
  const MiniAppsMostUsedSectionShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium shimmer palette (no pure black)
    final baseColor = isDark ? const Color(0xFF2A2F3A) : const Color(0xFFE7E9EF);
    final highlightColor = isDark ? const Color(0xFF3A4150) : const Color(0xFFF5F6FA);

    // Surfaces
    final cardBg = isDark ? const Color(0xFF141821) : Colors.white;
    final titleBg = isDark ? const Color(0xFF141821) : Colors.white;

    // Placeholders
    final iconBg = isDark ? const Color(0xFF1D2430) : Colors.white.withOpacity(0.55);
    final textBg = isDark ? const Color(0xFF1D2430) : Colors.white;

    // Subtle borders for premium feel
    final borderColor = isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04);

    final shadowColor = isDark ? Colors.black.withOpacity(0.35) : Colors.black.withOpacity(0.06);

    // Dimensions extracted from CustomMiniAppsCard in the parent widget:
    final double cardWidth = context.w(104);
    final double cardHeight = context.h(104);
    final double iconWidth = context.w(48);
    final double iconHeight = context.h(48);
    final double titlesWidth = context.w(66);
    final double titlesHeight = context.h(17);

    // Function to build a single card shimmer item
    Widget buildShimmerCard() {
      return Column(
        children: [
          // Card shimmer
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [BoxShadow(color: shadowColor, blurRadius: isDark ? 10 : 8, offset: const Offset(0, 6))],
              ),
              child: Center(
                child: Container(
                  width: iconWidth,
                  height: iconHeight,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.03),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: context.h(4)),

          // Title/Text shimmer
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: titlesWidth,
              height: titlesHeight,
              decoration: BoxDecoration(
                color: textBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor, width: 1),
              ),
            ),
          ),
        ],
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
            width: context.w(195),
            height: context.h(35),
            decoration: BoxDecoration(
              color: titleBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1),
              boxShadow: [BoxShadow(color: shadowColor, blurRadius: isDark ? 10 : 8, offset: const Offset(0, 6))],
            ),
          ),
        ),

        SizedBox(height: context.screenHeight * 0.01),

        // Horizontal list shimmer wrapper
        SizedBox(
          height: context.h(64),
          width: context.screenWidth,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: context.screenWidth * 0.03),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) => buildShimmerCard(),
          ),
        ),
      ],
    );
  }
}
