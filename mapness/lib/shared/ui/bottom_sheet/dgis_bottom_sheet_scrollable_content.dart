import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/pages/path_nav/lib/no_overscroll_behavior.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// widget contains scrollable common content layout for [DgisBottomSheet]: fixed header and scrollable body
class DgisBottomSheetScrollableContent extends StatelessWidget {
  const DgisBottomSheetScrollableContent({
    required this.header,
    required this.body,
    super.key,
    this.controller,
    this.bodyPadding = const EdgeInsets.all(8),
  });

  /// Pinned header, has handle and paddings
  final Widget header;

  /// Scrollable body widgets
  final List<Widget> body;

  /// padding for body content
  final EdgeInsetsGeometry bodyPadding;

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.color.surfaceBaseSecondary;

    return ScrollConfiguration(
      behavior: NoOverscrollBehavior(),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverPinnedHeader(child: header),
          SliverStack(
            children: [
              SliverPositioned.fill(
                child: Container(
                  color: backgroundColor,
                ),
              ),
              SliverPadding(
                padding: bodyPadding,
                sliver: SliverList.list(children: body),
              ),
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
