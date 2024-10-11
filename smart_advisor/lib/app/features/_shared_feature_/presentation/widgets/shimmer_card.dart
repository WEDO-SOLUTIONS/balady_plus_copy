import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/constants/app_colors.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard(
      {Key? key,
      this.margin,
      this.width,
      required this.height,
      this.borderRadius})
      : super(key: key);

  final double? margin;
  final double? width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width - 16,
      height: height,
      child: Shimmer.fromColors(
        baseColor: AppColor.textTertiaryColor.withAlpha(20),
        highlightColor: AppColor.white,
        period: const Duration(milliseconds: 1000),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
        ),
      ),
    );
  }
}

class ShimmerHorizontalList extends StatelessWidget {
  const ShimmerHorizontalList({Key? key, this.height = 150, this.width = 100})
      : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 14, end: 8),
        child: ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) => ShimmerCard(
            height: height,
            width: width,
            margin: 2,
          ),
        ),
      ),
    );
  }
}

class ShimmerVerticalList extends StatelessWidget {
  const ShimmerVerticalList({Key? key, this.height = 150}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (_, index) => ShimmerCard(
          height: height,
          margin: 2,
        ),
      ),
    );
  }
}
