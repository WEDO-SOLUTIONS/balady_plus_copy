import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/constants/app_colors.dart';

class Shimmer2Card extends StatelessWidget {
  const Shimmer2Card(
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
      height: 80,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white, // color ?? const Color(0xffE8EBEF),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
              baseColor: Color(0xffF3F6FF),
              highlightColor: AppColor.white,
              period: const Duration(milliseconds: 1000),
              child: Container(
                height: 12,
                width: MediaQuery.of(context).size.width * 0.70,
                decoration: BoxDecoration(
                  color: Color(0xffF3F6FF),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              )),
          const SizedBox(
            height: 16,
          ),
          Shimmer.fromColors(
              baseColor: Color(0xffF3F6FF),
              highlightColor: AppColor.white,
              period: const Duration(milliseconds: 1000),
              child: Container(
                height: 12,
                width: MediaQuery.of(context).size.width * 0.40,
                decoration: BoxDecoration(
                  color: Color(0xffF3F6FF), // color ?? const Color(0xffE8EBEF),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              )),
        ],
      ),
    );

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
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) => Shimmer2Card(
            height: height,
            width: width,
            margin: 2,
          ),
        ),
      ),
    );
  }
}

class Shimmer2VerticalList extends StatelessWidget {
  const Shimmer2VerticalList({Key? key, this.height = 150, this.count})
      : super(key: key);

  final double height;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: count ?? 5,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (_, index) => Shimmer2Card(
          height: height,
          margin: 2,
        ),
      ),
    );
  }
}
