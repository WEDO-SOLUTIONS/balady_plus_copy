import 'package:flutter/material.dart';

/// This widget is used to wrap in [PageView] cards if amount of cards is more then one
/// If amount is more then one we set the default width for [PathCard] (but we set it earlier when we setup [PageController] and [viewportFraction])
class RouteCarouselWrapper extends StatefulWidget {
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
  State<RouteCarouselWrapper> createState() => _RouteCarouselWrapperState();
}

class _RouteCarouselWrapperState extends State<RouteCarouselWrapper> {
  // Do not use PageView.onPageChanged to determine page number as it breaks on last page.
  // See https://github.com/flutter/flutter/issues/24763
  late int _pageIndex = widget.pageController.initialPage;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_onScrollUpdate);
  }

  void _onScrollUpdate() {
    final pageIndex = widget.pageController.page;
    if (pageIndex == null) {
      return;
    }
    final intPageIndex = (pageIndex + (1 - widget.pageController.viewportFraction) / 2).round();
    if (intPageIndex != _pageIndex) {
      _pageIndex = intPageIndex;
      widget.onActiveChanged(intPageIndex);
    }
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_onScrollUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.routesCount == 1) {
      return widget.itemBuilder(context, 0);
    }
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: widget.pageController,
        onPageChanged: widget.onActiveChanged,
        padEnds: false,
        itemBuilder: widget.itemBuilder,
        itemCount: widget.routesCount,
      ),
    );
  }
}
