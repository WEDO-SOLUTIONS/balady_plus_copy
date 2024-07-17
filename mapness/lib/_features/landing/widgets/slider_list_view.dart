import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderListView<T> extends StatefulWidget {
  final List<T> items;
  final double contentHeight;
  final bool vibrateOnChange;

  final void Function(T item)? onTap;
  final Widget Function(T? item) itemBuilder;

  const SliderListView({
    required this.items,
    required this.itemBuilder,
    required this.contentHeight,
    this.vibrateOnChange = true,
    this.onTap,
    super.key,
  });

  @override
  State<SliderListView<T>> createState() => _SliderListViewState<T>();
}

class _SliderListViewState<T> extends State<SliderListView<T>> {
  late final PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(RadiusBorder.xl),
              child: SizedBox(
                height: widget.contentHeight,
                child: widget.items.isEmpty
                    ? widget.itemBuilder(null)
                    : PageView.builder(
                        reverse: context.isRTL,
                        padEnds: false,
                        physics: const BouncingScrollPhysics(),
                        controller: controller,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];

                          return GestureDetector(
                            onTap: () => widget.onTap?.call(item),
                            child: widget.itemBuilder(item),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: Spacing.$3x),
            if (widget.items.isNotEmpty)
              SmoothPageIndicator(
                textDirection: TextDirection.ltr,
                onDotClicked: (index) {
                  controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                  );
                },
                controller: controller,
                count: widget.items.length,
                effect: ScrollingDotsEffect(
                  radius: 100.0,
                  dotWidth: 6.0,
                  dotHeight: 6.0,
                  dotColor: context.colorsV2.foregroundDisabled,
                  activeDotColor: context.colorsV2.foregroundDefault,
                ),
              ),
          ],
        ),
      );
}
