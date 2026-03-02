import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class AppsGroupSectionShimmerWidget extends StatelessWidget {
  const AppsGroupSectionShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // GridView specific dimensions:
    final double gridViewHeight = context.screenHeight * 0.55;
    const int itemCount = 4;
    final double mainAxisSpacing = context.screenHeight * 0.02;
    final double crossAxisSpacing = context.screenWidth * 0.04;
    const double childAspectRatio = 0.8;

    // CustomLargMoreApps default dimensions:
    final double cardOuterWidth = context.w(168); // The main DecoratedBox width
    final double cardOuterHeight = context.h(168); // The main DecoratedBox height
    final double textContainerWidth = context.screenWidth * 0.20;
    final double textContainerHeight = context.screenHeight * 0.04;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Matches the parent Column
      children: [
        SizedBox(
          height: gridViewHeight, // Matches the SizedBox wrapper height
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              // Start of INLINE Shimmer Item for CustomLargMoreApps
              return Column(
                mainAxisSize: MainAxisSize.min, // Matches CustomLargMoreApps
                children: [
                  // Main card shimmer (DecoratedBox + SizedBox)
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: cardOuterWidth,
                      height: cardOuterHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      // Inner content of the large card: mimic the 2x2 layout
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Shimmer for CustomSubCardsOfLargCard
                              Container(
                                width: cardOuterWidth * 0.35, // Approx size
                                height: cardOuterHeight * 0.35, // Approx size
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Container(
                                width: cardOuterWidth * 0.35, // Approx size
                                height: cardOuterHeight * 0.35, // Approx size
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.screenHeight * 0.02), // Matches spacing
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Shimmer for CustomSubCardsOfLargCard
                              Container(
                                width: cardOuterWidth * 0.35, // Approx size
                                height: cardOuterHeight * 0.35, // Approx size
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              // Shimmer for CustomNumberOfAppsSubCard (can be similar to others)
                              Container(
                                width: cardOuterWidth * 0.35, // Approx size
                                height: cardOuterHeight * 0.35, // Approx size
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  // Text container shimmer (below the main card)
                  SizedBox(height: context.h(8)), // Inferred small spacing
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: textContainerWidth,
                      height: textContainerHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              );
              // End of INLINE Shimmer Item
            },
          ),
        ),
      ],
    );
  }
}
