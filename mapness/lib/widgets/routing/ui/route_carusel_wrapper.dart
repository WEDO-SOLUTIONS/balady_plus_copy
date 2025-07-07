import 'package:flutter/material.dart';

/// This widget is used to wrap in [PageView] cards if amount of cards is more then one
/// If amount is more then one we set the default width for [PathCard] (but we set it earlier when we setup [PageController] and [viewportFraction])
class RouteCarouselWrapper extends StatelessWidget {
  final double height;
  final PageController pageController;
  final int routesCount;
  final ValueChanged<int> onActiveChanged;
  final Widget Function(BuildContext, int) itemBuilder;

  const RouteCarouselWrapper({
    required this.itemBuilder,
    required this.routesCount,
    required this.height,
    required this.pageController,
    required this.onActiveChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (routesCount == 1) {
      return itemBuilder(context, 0);
    }
    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: pageController,
        onPageChanged: onActiveChanged,
        padEnds: false,
        itemBuilder: itemBuilder,
        itemCount: routesCount,
      ),
    );
  }
}
