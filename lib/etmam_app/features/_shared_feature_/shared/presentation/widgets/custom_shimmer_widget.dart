import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerListWidget extends StatelessWidget {
  final double height;
  final int? itemCount;
  final EdgeInsets? padding;

  const CustomShimmerListWidget({
    Key? key,
    required this.height,
    this.itemCount,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: itemCount ?? 10,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: padding ?? const EdgeInsets.all(8.0),
            child: CustomShimmerWidget(
              childHeight: height,
            ),
          );
        });
  }
}

class CustomShimmerHorizontalListWidget extends StatelessWidget {
  final double? width;
  final double height;
  final int? itemCount;
  final EdgeInsets? padding;

  const CustomShimmerHorizontalListWidget({
    Key? key,
    this.width,
    this.height = 100,
    this.itemCount,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height + 5,
      child: ListView.builder(
          itemCount: itemCount ?? 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: padding ?? const EdgeInsets.all(8.0),
              child: CustomShimmerWidget(
                childWidth: width ?? MediaQuery.of(context).size.width / 2,
                childHeight: height,
              ),
            );
          }),
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

  const CustomShimmerGridViewWidget(
      {Key? key,
      required this.height,
      this.width = double.infinity,
      this.itemCount,
      this.padding,
      this.crossAxisCount = 2,
      this.mainAxisSpacing = 12,
      this.mainAxisExtent = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount ?? 10,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return Padding(
          padding: padding ?? const EdgeInsets.all(8.0),
          child: CustomShimmerWidget(
            childWidth: width,
            childHeight: height,
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          mainAxisExtent: height),
    );
  }
}

class CustomShimmerWidget extends StatelessWidget {
  final Widget? childWidget;
  final double? childHeight;
  final double? childWidth;
  final EdgeInsets? padding;

  const CustomShimmerWidget(
      {Key? key,
      this.childWidget,
      this.childHeight,
      this.childWidth,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: childWidget ??
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                color: Colors.white,
              ),
              height: childHeight ?? 100,
              width: childWidth ?? double.infinity,
            ),
      ),
    );
  }
}
