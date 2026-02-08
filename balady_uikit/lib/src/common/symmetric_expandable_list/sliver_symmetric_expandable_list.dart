import 'dart:math';

import 'package:balady_uikit/src/common/symmetric_expandable_list/symmetric_scroll_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Creates a scrollable list of widgets
///
/// If the size of the widgets less or equels to the outside constraints, expand the childrens evenly.
class SliverSymmetricExpandableList extends SliverMultiBoxAdaptorWidget {
  final double? contentPadding;
  final double? separationPadding;
  final SymmetricScrollController? scrollController;

  const SliverSymmetricExpandableList({
    required super.delegate,
    this.scrollController,
    this.contentPadding,
    this.separationPadding,
    super.key,
  });

  @override
  SliverMultiBoxAdaptorElement createElement() => SliverMultiBoxAdaptorElement(this, replaceMovedChildren: true);

  @override
  RenderSliverSymmetricExpandableList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element = context as SliverMultiBoxAdaptorElement;
    return RenderSliverSymmetricExpandableList(
      childManager: element,
      contentPadding: contentPadding ?? 0,
      separationPadding: separationPadding ?? 0,
      scrollController: scrollController,
    );
  }
}

class RenderSliverSymmetricExpandableList extends RenderSliverList {
  final double contentPadding;
  final double separationPadding;
  final SymmetricScrollController? scrollController;

  RenderSliverSymmetricExpandableList({
    required super.childManager,
    this.scrollController,
    this.contentPadding = 0,
    this.separationPadding = 0,
  });

  // Returns the right size for scroll direction axis.
  double sizeExtentOf(Size size) {
    switch (constraints.axis) {
      case Axis.horizontal:
        return size.width;
      case Axis.vertical:
        return size.height;
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController?.attachListCallback(childCount, (index) {
        var currentIndex = 0;
        double position = 0.0;
        RenderBox? child = firstChild;

        while (child != null && currentIndex != index + 1) {
          child = childAfter(child);
          currentIndex++;
        }

        if (child != null) {
          final childPosition =
              (childScrollOffset(child) ?? 0) - constraints.viewportMainAxisExtent / 2 + sizeExtentOf(child.size) / 2;
          final maxScrollPosition =
              (geometry?.scrollExtent ?? 0) - constraints.viewportMainAxisExtent + contentPadding * 2;

          position = max(0, min(childPosition, maxScrollPosition));
        }

        return position;
      });
    });
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! SymmetricExpandableParentData) {
      child.parentData = SymmetricExpandableParentData();
    }
  }

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    childManager
      ..didStartLayout()
      ..setDidUnderflow(false);

    final double scrollOffset = constraints.scrollOffset + constraints.cacheOrigin;
    assert(scrollOffset >= 0.0, 'scrollOffset should not be negative');

    final double remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0, 'remainingExtent should not be negative');

    final double targetEndScrollOffset = scrollOffset + remainingExtent + separationPadding;
    final BoxConstraints childConstraints = constraints.asBoxConstraints();

    final avaliableSpace = constraints.viewportMainAxisExtent - contentPadding * 2;

    int leadingGarbage = 0;
    int trailingGarbage = 0;
    bool reachedEnd = false;

    // Make sure we have at least one child to start from.
    if (firstChild == null) {
      if (!addInitialChild()) {
        // There are no children.
        geometry = SliverGeometry.zero;
        childManager.didFinishLayout();
        return;
      }
    }

    // We have at least one child.

    // These variables track the range of children that we have laid out. Within
    // this range, the children have consecutive indices. Outside this range,
    // it's possible for a child to get removed without notice.
    RenderBox? leadingChildWithLayout, trailingChildWithLayout;

    RenderBox? earliestUsefulChild = firstChild;

    double childrenAllocatedSpace = 0.0;
    double noExpandChildrenAllocatedSpace = 0.0;

    final isHorizontal =
        constraints.axisDirection == AxisDirection.left || constraints.axisDirection == AxisDirection.right;

    // List of children sizes that we need to calculate the minimum size of the render box.
    final List<Size> childrenSizes = [];

    int noExpandableChildren = 0;

    // Until the children sizes is not exceeded the size of viewport, we accumulate it.
    while (earliestUsefulChild != null &&
        childrenAllocatedSpace + (childCount * separationPadding) - separationPadding <= avaliableSpace) {
      final childSize = ChildLayoutHelper.dryLayoutChild(earliestUsefulChild, childConstraints);

      // Check if the child is requesting to no expand.
      final parentData = earliestUsefulChild.parentData as SymmetricExpandableParentData?;

      final childDataIsNotExpandable = !(parentData?.isExpanded ?? true);
      // And if the child is requesting to no expand, store their sizes
      if (childDataIsNotExpandable) {
        noExpandableChildren++;
        if (isHorizontal) {
          noExpandChildrenAllocatedSpace += childSize.width;
        } else {
          noExpandChildrenAllocatedSpace += childSize.height;
        }
      } else {
        // Store sizes of the expandable children.
        childrenSizes.add(childSize);
      }

      if (isHorizontal) {
        childrenAllocatedSpace += childSize.width;
      } else {
        childrenAllocatedSpace += childSize.height;
      }

      earliestUsefulChild = insertAndLayoutChild(
        childConstraints,
        after: earliestUsefulChild,
        parentUsesSize: true,
      );
    }

    earliestUsefulChild = firstChild;

    // If the children sizes are fit inside the viewport, we adjust them to fit entire viewport.
    if (childrenAllocatedSpace + (childCount * separationPadding) - separationPadding <= avaliableSpace) {
      double childMainPosition = 0.0;

      var child = earliestUsefulChild;
      var index = 0;

      // Calculate the size of ideal child to place inside the viewport, pretending that no expand children are not exist.
      var expandedChildrenSize =
          avaliableSpace - noExpandChildrenAllocatedSpace - (childCount * separationPadding) + separationPadding;
      var spaceForChild = expandedChildrenSize / (childCount - noExpandableChildren);

      // Accumulate delta size of children that are larger than the ideal child and recalculate ideal child size.
      var childrenWithOverflow = 0;
      for (final childSize in childrenSizes) {
        if (sizeExtentOf(childSize) > spaceForChild) {
          expandedChildrenSize -= sizeExtentOf(childSize);
          childrenWithOverflow++;
          spaceForChild = expandedChildrenSize / (childCount - noExpandableChildren - childrenWithOverflow);
        }
      }

      // Laying out the children with new constraints.
      while (child != null) {
        (child.parentData! as SliverMultiBoxAdaptorParentData).layoutOffset = childMainPosition;

        final BoxConstraints layoutChildContraints;

        final parentData = child.parentData as SymmetricExpandableParentData?;
        final childDataIsNotExpandable = !(parentData?.isExpanded ?? true);

        // Laying out the child without ajusting constraints.
        if (childDataIsNotExpandable) {
          layoutChildContraints = isHorizontal
              ? BoxConstraints(maxHeight: childConstraints.maxHeight)
              : BoxConstraints(maxWidth: childConstraints.maxWidth);
        } else {
          // Get the maximum child size based on the ideal child size.
          final minMainSize =
              childrenSizes.length > index ? max(spaceForChild, sizeExtentOf(childrenSizes[index])) : 0.0;

          layoutChildContraints = isHorizontal
              ? BoxConstraints(
                  minWidth: minMainSize,
                  maxWidth: minMainSize,
                  maxHeight: childConstraints.maxHeight,
                )
              : BoxConstraints(
                  minHeight: minMainSize,
                  maxHeight: minMainSize,
                  maxWidth: childConstraints.maxWidth,
                );

          index++;
        }

        child.layout(layoutChildContraints, parentUsesSize: true);

        childMainPosition += sizeExtentOf(child.size) + separationPadding;

        child = childAfter(child);
      }

      geometry = SliverGeometry(
        scrollExtent: avaliableSpace,
        paintExtent: avaliableSpace,
        maxPaintExtent: avaliableSpace,
      );

      childManager.didFinishLayout();
      return;
    }

    // A firstChild with null layout offset is likely a result of children
    // reordering.
    //
    // We rely on firstChild to have accurate layout offset. In the case of null
    // layout offset, we have to find the first child that has valid layout
    // offset.
    if (childScrollOffset(firstChild!) == null) {
      int leadingChildrenWithoutLayoutOffset = 0;
      while (earliestUsefulChild != null && childScrollOffset(earliestUsefulChild) == null) {
        earliestUsefulChild = childAfter(earliestUsefulChild);
        leadingChildrenWithoutLayoutOffset += 1;
      }
      // We should be able to destroy children with null layout offset safely,
      // because they are likely outside of viewport
      collectGarbage(leadingChildrenWithoutLayoutOffset, 0);
      // If can not find a valid layout offset, start from the initial child.
      if (firstChild == null) {
        if (!addInitialChild()) {
          // There are no children.
          geometry = SliverGeometry.zero;
          childManager.didFinishLayout();
          return;
        }
      }
    }

    // Find the last child that is at or before the scrollOffset.
    earliestUsefulChild = firstChild;
    for (double earliestScrollOffset = childScrollOffset(earliestUsefulChild!)!;
        earliestScrollOffset > scrollOffset;
        earliestScrollOffset = childScrollOffset(earliestUsefulChild)!) {
      // We have to add children before the earliestUsefulChild.
      earliestUsefulChild = insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);
      if (earliestUsefulChild == null) {
        (firstChild!.parentData! as SliverMultiBoxAdaptorParentData).layoutOffset = 0.0;

        if (scrollOffset == 0.0) {
          // insertAndLayoutLeadingChild only lays out the children before
          // firstChild. In this case, nothing has been laid out. We have
          // to lay out firstChild manually.
          firstChild!.layout(childConstraints, parentUsesSize: true);
          earliestUsefulChild = firstChild;
          leadingChildWithLayout = earliestUsefulChild;
          trailingChildWithLayout ??= earliestUsefulChild;
          break;
        } else {
          // We ran out of children before reaching the scroll offset.
          // We must inform our parent that this sliver cannot fulfill
          // its contract and that we need a scroll offset correction.
          geometry = SliverGeometry(
            scrollOffsetCorrection: -scrollOffset,
          );
          return;
        }
      }

      final double firstChildScrollOffset = earliestScrollOffset - paintExtentOf(firstChild!) - separationPadding;
      // firstChildScrollOffset may contain double precision error
      if (firstChildScrollOffset < -precisionErrorTolerance) {
        // Let's assume there is no child before the first child. We will
        // correct it on the next layout if it is not.
        geometry = SliverGeometry(
          scrollOffsetCorrection: -firstChildScrollOffset,
        );

        (firstChild!.parentData! as SliverMultiBoxAdaptorParentData).layoutOffset = 0.0;
        return;
      }

      (earliestUsefulChild.parentData! as SliverMultiBoxAdaptorParentData).layoutOffset = firstChildScrollOffset;
      assert(earliestUsefulChild == firstChild, '');
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout ??= earliestUsefulChild;
    }

    assert(childScrollOffset(firstChild!)! > -precisionErrorTolerance, '');

    // If the scroll offset is at zero, we should make sure we are
    // actually at the beginning of the list.
    if (scrollOffset < precisionErrorTolerance) {
      // We iterate from the firstChild in case the leading child has a 0 paint
      // extent.
      while (indexOf(firstChild!) > 0) {
        final double earliestScrollOffset = childScrollOffset(firstChild!)!;
        // We correct one child at a time. If there are more children before
        // the earliestUsefulChild, we will correct it once the scroll offset
        // reaches zero again.
        earliestUsefulChild = insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);
        assert(earliestUsefulChild != null, '');
        final double firstChildScrollOffset = earliestScrollOffset - paintExtentOf(firstChild!) - separationPadding;

        (firstChild!.parentData! as SliverMultiBoxAdaptorParentData).layoutOffset = 0.0;
        // We only need to correct if the leading child actually has a
        // paint extent.
        if (firstChildScrollOffset < -precisionErrorTolerance) {
          geometry = SliverGeometry(
            scrollOffsetCorrection: -firstChildScrollOffset - separationPadding,
          );
          return;
        }
      }
    }

    // At this point, earliestUsefulChild is the first child, and is a child
    // whose scrollOffset is at or before the scrollOffset, and
    // leadingChildWithLayout and trailingChildWithLayout are either null or
    // cover a range of render boxes that we have laid out with the first being
    // the same as earliestUsefulChild and the last being either at or after the
    // scroll offset.

    // Make sure we've laid out at least one child.
    if (leadingChildWithLayout == null) {
      earliestUsefulChild!.layout(childConstraints, parentUsesSize: true);
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout = earliestUsefulChild;
    }

    // Here, earliestUsefulChild is still the first child, it's got a
    // scrollOffset that is at or before our actual scrollOffset, and it has
    // been laid out, and is in fact our leadingChildWithLayout. It's possible
    // that some children beyond that one have also been laid out.

    bool inLayoutRange = true;
    RenderBox? child = earliestUsefulChild;
    int index = indexOf(child!);
    double endScrollOffset = childScrollOffset(child)! + paintExtentOf(child) + separationPadding;
    bool advance() {
      // returns true if we advanced, false if we have no more children
      // This function is used in two different places below, to avoid code duplication.
      assert(child != null, 'child should not be null');
      if (child == trailingChildWithLayout) {
        inLayoutRange = false;
      }
      child = childAfter(child!);
      if (child == null) {
        inLayoutRange = false;
      }
      index += 1;
      if (!inLayoutRange) {
        if (child == null || indexOf(child!) != index) {
          // We are missing a child. Insert it (and lay it out) if possible.
          child = insertAndLayoutChild(
            childConstraints,
            after: trailingChildWithLayout,
            parentUsesSize: true,
          );
          if (child == null) {
            // We have run out of children.
            return false;
          }
        } else {
          // Lay out the child.
          child!.layout(childConstraints, parentUsesSize: true);
        }
        trailingChildWithLayout = child;
      }
      assert(child != null, 'child must not be null');

      (child!.parentData! as SliverMultiBoxAdaptorParentData).layoutOffset = endScrollOffset;

      endScrollOffset = childScrollOffset(child!)! + paintExtentOf(child!) + separationPadding;
      return true;
    }

    // Find the first child that ends after the scroll offset.
    while (endScrollOffset < scrollOffset) {
      leadingGarbage += 1;
      if (!advance()) {
        assert(child == null, 'child must not be null');
        // we want to make sure we keep the last child around so we know the end scroll offset
        collectGarbage(leadingGarbage - 1, 0);

        final double extent = childScrollOffset(lastChild!)! + paintExtentOf(lastChild!);
        geometry = SliverGeometry(
          scrollExtent: extent,
          maxPaintExtent: extent,
        );
        return;
      }
    }

    // Now find the first child that ends after our end.
    while (endScrollOffset < targetEndScrollOffset) {
      if (!advance()) {
        endScrollOffset -= separationPadding;
        reachedEnd = true;
        break;
      }
    }

    // Finally count up all the remaining children and label them as garbage.
    if (child != null) {
      child = childAfter(child!);
      while (child != null) {
        trailingGarbage += 1;
        child = childAfter(child!);
      }
    }

    // At this point everything should be good to go, we just have to clean up
    // the garbage and report the geometry.

    collectGarbage(leadingGarbage, trailingGarbage);

    final double estimatedMaxScrollOffset;
    if (reachedEnd) {
      estimatedMaxScrollOffset = endScrollOffset;
    } else {
      estimatedMaxScrollOffset = childManager.estimateMaxScrollOffset(
        constraints,
        firstIndex: indexOf(firstChild!),
        lastIndex: indexOf(lastChild!),
        leadingScrollOffset: childScrollOffset(firstChild!),
        trailingScrollOffset: endScrollOffset,
      );
    }
    final double paintExtent = calculatePaintOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: endScrollOffset,
    );
    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: endScrollOffset,
    );
    final double targetEndScrollOffsetForPaint = constraints.scrollOffset + constraints.remainingPaintExtent;
    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: estimatedMaxScrollOffset,
      // Conservative to avoid flickering away the clip during scroll.
      hasVisualOverflow: endScrollOffset > targetEndScrollOffsetForPaint || constraints.scrollOffset > 0.0,
    );

    // We may have started the layout while scrolled to the end, which would not
    // expose a new child.
    if (estimatedMaxScrollOffset == endScrollOffset) {
      childManager.setDidUnderflow(true);
    }
    childManager.didFinishLayout();
  }

  (Rect, Rect) getRectangleBoxes(int leftIndex, int rightIndex) {
    var currentIndex = 0;
    var foundRects = 0;

    double leftRectOffsetStartsAt = 0.0;
    double leftRectWidth = 0.0;

    double rightRectOffsetStartsAt = 0.0;
    double rightRectWidth = 0.0;

    RenderBox? child;
    final isRtL = axisDirectionIsReversed(constraints.axisDirection);

    final startsAt = isRtL ? geometry!.paintExtent : 0.0;

    child = firstChild;

    while (foundRects < 2 && child != null && currentIndex != max(leftIndex, rightIndex) + 1) {
      if (leftIndex == currentIndex) {
        leftRectOffsetStartsAt = childScrollOffset(child) ?? 0.0;
        leftRectWidth = sizeExtentOf(child.size);
        if (isRtL) {
          leftRectOffsetStartsAt = startsAt - leftRectOffsetStartsAt - leftRectWidth;
        }
        foundRects++;
      }

      if (rightIndex == currentIndex) {
        rightRectOffsetStartsAt = childScrollOffset(child) ?? 0.0;
        rightRectWidth = sizeExtentOf(child.size);
        if (isRtL) {
          rightRectOffsetStartsAt = startsAt - rightRectOffsetStartsAt - rightRectWidth;
        }
        foundRects++;
      }

      child = childAfter(child);

      currentIndex++;
    }

    final leftRect = Rect.fromLTWH(
      leftRectOffsetStartsAt,
      0.0,
      leftRectWidth,
      paintBounds.size.height,
    );

    final rightRect = Rect.fromLTWH(
      rightRectOffsetStartsAt,
      0.0,
      rightRectWidth,
      paintBounds.size.height,
    );

    return (leftRect, rightRect);
  }
}

class SymmetricExpandableParentData extends SliverMultiBoxAdaptorParentData {
  bool isExpanded = true;
}
