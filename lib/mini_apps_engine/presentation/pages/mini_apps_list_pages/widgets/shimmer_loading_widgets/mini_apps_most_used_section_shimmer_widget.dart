import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class MiniAppsMostUsedSectionShimmerWidget extends StatelessWidget {
  const MiniAppsMostUsedSectionShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Icon Container Shimmer (The main card body)
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              // We can add a sub-shimmer for the icon inside if needed,
              // but usually, the main box is enough for the effect.
              // We'll keep it simple for now as the card defines its own size.
              child: Center(
                child: Container(
                  width: iconWidth,
                  height: iconHeight,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5), // A slightly different shade for the icon area
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          // Title/Text Shimmer
          SizedBox(height: context.h(4)), // Small spacing for visual separation
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: titlesWidth,
              height: titlesHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title shimmer (Matches CustomSubHeadingText default size)
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: context.w(195), // Default width from CustomSubHeadingText
            height: context.h(35), // Default height from CustomSubHeadingText
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        SizedBox(height: context.screenHeight * 0.01), // Matches spacing

        // Horizontal list shimmer wrapper
        SizedBox(
          height: context.screenHeight * 0.20, // Matches height
          width: context.screenWidth, // Matches width
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(width: context.screenWidth * 0.03); // Matches separator
            },
            scrollDirection: Axis.horizontal,
            itemCount: 4, // Shimmer a few items
            itemBuilder: (context, index) {
              return buildShimmerCard();
            },
          ),
        ),
      ],
    );
  }
}
