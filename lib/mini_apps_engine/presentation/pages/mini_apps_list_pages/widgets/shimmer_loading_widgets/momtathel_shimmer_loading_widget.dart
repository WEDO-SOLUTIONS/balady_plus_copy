import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//!
class MomtathelCardShimmer extends StatelessWidget {
  const MomtathelCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF2A2F3A) : const Color(0xFFE7E9EF);
    final highlightColor = isDark ? const Color(0xFF3A4150) : const Color(0xFFF5F6FA);

    return Padding(
      padding: EdgeInsets.only(
        left: CommonFunctions.isAppAR ? context.screenWidth * 0.04 : context.screenWidth * 0.00,
        right: CommonFunctions.isAppAR ? context.screenWidth * 0.00 : context.screenWidth * 0.04,
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11.19),
          child: Container(
            // NOTE: You may need to hardcode a height here that roughly matches
            // the height of your "momtathel.png" asset so the UI doesn't jump.
            height: context.h(110),
            width: double.infinity,
            color: Colors.white, // Setting color here allows Shimmer to draw the background
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 1. Shimmer for the "New" badge
                  Container(
                    width: context.w(45),
                    height: context.h(24),
                    decoration: BoxDecoration(
                      // Using black/white inside the Shimmer widget makes it solid
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. Shimmer for the title text
                  Container(
                    height: 14,
                    width: context.screenWidth * 0.35,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(height: 8),

                  // 3. Shimmer for the subtitle text
                  Container(
                    height: 13,
                    width: context.screenWidth * 0.55,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
