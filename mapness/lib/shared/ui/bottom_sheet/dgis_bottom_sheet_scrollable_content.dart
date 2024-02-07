import 'package:flutter/material.dart';
import 'package:mapness/pages/path_nav/lib/no_overscroll_behavior.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet_theme.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// widget contains scrollable common content layout for [DgisBottomSheet]: fixed header and scrollable body
class DgisBottomSheetScrollableContent extends StatelessWidget {
  /// Pinned header, has handle and paddings
  final Widget header;

  /// Scrollable body widgets
  final List<Widget> body;

  /// padding for body content
  final EdgeInsetsGeometry bodyPadding;

  final ScrollController? controller;

  const DgisBottomSheetScrollableContent({
    required this.header,
    required this.body,
    super.key,
    this.controller,
    this.bodyPadding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        DgisBottomSheetTheme.defaultTheme.bodyBackgroundColor;

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
          )
        ],
      ),
    );
  }
}
