import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class MiniAppsFavSectionShimmerWidget extends StatelessWidget {
  const MiniAppsFavSectionShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double iconWidth = context.w(53.95);
    final double iconHeight = context.h(53.95);
    final double titlesWidth = context.w(55.21214294433594);
    final double titlesHeight = context.h(29.814556121826172);

    Widget buildShimmerItem(BuildContext context, bool isDashedAdd) {
      return Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: iconWidth,
              height: iconHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isDashedAdd
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
            ),
          ),
          // Text Shimmer
          SizedBox(height: context.h(4)),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: titlesWidth,
              height: titlesHeight * 0.5,
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
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: context.w(170),
            height: context.h(33),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: context.screenHeight * 0.02),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildShimmerItem(context, true),
            SizedBox(width: context.screenWidth * 0.04),
            SizedBox(
              height: context.screenHeight * 0.13,
              width: context.screenWidth * 0.70,
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(width: context.screenWidth * 0.03);
                },
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return buildShimmerItem(context, false);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
