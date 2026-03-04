import 'package:balady_uikit/src/common/symmetric_expandable_list/sliver_symmetric_expandable_list.dart';
import 'package:balady_uikit/src/common/symmetric_expandable_list/symmetric_scroll_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A [SymmetricExpandableList] is a wrapping content component,
/// used mostly for displaying row of buttons.
///
/// A widget layouting it's [children] based on size of viewport.
/// If the `size of the viewport >= size of the children`,
/// wrapper incourage children to fill the remaining space equaly, by expanding their constraints.
/// Else wrapper will be behaving like a [ListView].
///
/// Wrap child with [NoExpand] to disable inflating the size of this child.
///
/// Use [contentPadding] parameter to add padding around the list.
///
/// Use [separationPadding] parameter to add padding between the [children].
///
/// Use [SymmetricScrollController] as a [controller] to have ability to animate to items by index.
class SymmetricExpandableList extends StatefulWidget {
  final List<Widget> children;
  final Axis scrollDirection;
  final ScrollPhysics physics;
  final SymmetricScrollController? controller;
  final double? contentPadding;
  final double? contentCrossAxisPadding;
  final double? separationPadding;

  const SymmetricExpandableList({
    required this.children,
    this.controller,
    this.scrollDirection = Axis.horizontal,
    this.physics = const BouncingScrollPhysics(),
    this.contentPadding,
    this.separationPadding,
    this.contentCrossAxisPadding,
    super.key,
  });

  @override
  State<SymmetricExpandableList> createState() => _SymmetricExpandableListState();
}

class _SymmetricExpandableListState extends State<SymmetricExpandableList> {
  @override
  Widget build(BuildContext context) {
    final double horizontalPadding;
    final double verticalPadding;

    if (widget.scrollDirection == Axis.horizontal) {
      horizontalPadding = widget.contentPadding ?? 0;
      verticalPadding = widget.contentCrossAxisPadding ?? 0;
    } else {
      horizontalPadding = widget.contentCrossAxisPadding ?? 0;
      verticalPadding = widget.contentPadding ?? 0;
    }

    return CustomScrollView(
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      controller: widget.controller,
      clipBehavior: Clip.none,
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
      }),
      slivers: [
        SliverPadding(
          padding: widget.contentPadding == null
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
          sliver: SliverSymmetricExpandableList(
            contentPadding: widget.contentPadding,
            separationPadding: widget.separationPadding,
            scrollController: widget.controller,
            delegate: SliverChildListDelegate(
              widget.children,
              addSemanticIndexes: false,
              addRepaintBoundaries: false,
              addAutomaticKeepAlives: false,
            ),
          ),
        ),
      ],
    );
  }
}
