import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//!
class FavPageShimmerLoadingWidget extends StatelessWidget {
  const FavPageShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900]! : Colors.grey[300]!,
      highlightColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[100]!,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: context.screenHeight * 0.02),
        scrollDirection: Axis.vertical,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            width: context.screenWidth,
            height: context.h(64),
            decoration: BoxDecoration(
              //   color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}
