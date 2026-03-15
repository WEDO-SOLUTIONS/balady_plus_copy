import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/constants/constants.dart';

class CustomShimmerListWidget extends StatelessWidget {
  final double height;
  final int? itemCount;
  final EdgeInsets? padding;

  const CustomShimmerListWidget({super.key, required this.height, this.itemCount, this.padding});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount ?? 10,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: padding ?? const EdgeInsets.all(8.0),
          child: CustomShimmerWidget(childHeight: height),
        );
      },
    );
  }
}

class CustomShimmerWidget extends StatelessWidget {
  final Widget? childWidget;
  final double? childHeight;
  final double? childWidth;
  final EdgeInsets? padding;

  const CustomShimmerWidget({super.key, this.childWidget, this.childHeight, this.childWidth, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child:
            childWidget ??
            Container(
              decoration: Constants.boxDecorationWithShadowAndRoundedCorner,
              height: childHeight ?? 100,
              width: childWidth ?? double.infinity,
            ),
      ),
    );
  }
}

class CustomShimmerGridViewWidget extends StatelessWidget {
  final double width;
  final double height;
  final int? itemCount;
  final EdgeInsets? padding;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double mainAxisExtent;

  const CustomShimmerGridViewWidget({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.itemCount,
    this.padding,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 16,
    this.mainAxisExtent = 100,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount ?? 10,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: padding ?? const EdgeInsets.all(8.0),
          child: CustomShimmerWidget(childWidth: width, childHeight: height),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        mainAxisExtent: mainAxisExtent,
      ),
    );
  }
}
