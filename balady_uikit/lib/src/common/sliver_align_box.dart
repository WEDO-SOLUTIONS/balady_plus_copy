import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

enum _SliverAlignWidgets {
  child,
  sliver,
}

/// A sliver widget that aligns the Box [child] at the top of the viewport and [sliver] widget.
class SliverAlignBox extends SlottedMultiChildRenderObjectWidget<_SliverAlignWidgets, RenderObject> {
  final Widget sliver;
  final Widget child;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry padding;

  /// A widget that aligns its child at the top of a sliver.
  ///
  /// This widget is useful when you want to place a child widget at the top
  /// of a scrollable area, such as a CustomScrollView.
  ///
  /// The `SliverAlignBox` widget takes two children, a box [child] widget,
  /// which is aligned at the top of the [sliver] widget in current viewport.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// CustomScrollView(
  ///   slivers: [
  ///     SliverAlignBox(
  ///       alignment: Alignment.topCenter,
  ///       child: YourWidget(),
  ///       sliver: YourSliver(), // Other slivers
  ///     ),
  ///   ],
  /// )
  /// ```
  const SliverAlignBox({
    required this.sliver,
    required this.child,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  @override
  _RenderSliverAlignBox createRenderObject(BuildContext context) => _RenderSliverAlignBox(
        alignment: alignment,
        padding: padding,
        textDirection: Directionality.of(context),
      );

  @override
  void updateRenderObject(BuildContext context, covariant _RenderSliverAlignBox renderObject) {
    renderObject
      ..alignment = alignment
      ..textDirection = Directionality.of(context)
      ..padding = padding;
  }

  @override
  Widget? childForSlot(_SliverAlignWidgets slot) => switch (slot) {
        _SliverAlignWidgets.child => child,
        _SliverAlignWidgets.sliver => sliver,
      };

  @override
  Iterable<_SliverAlignWidgets> get slots => _SliverAlignWidgets.values;
}

class _RenderSliverAlignBox extends RenderSliver
    with RenderSliverHelpers, SlottedContainerRenderObjectMixin<_SliverAlignWidgets, RenderObject> {
  /// Gets the padding for the box child.
  ///
  /// Returns an [EdgeInsetsGeometry] object that defines the padding.
  ///
  /// If this is set to an [EdgeInsetsDirectional] object, then
  /// [textDirection] must not be null.
  EdgeInsetsGeometry get padding => _padding;
  EdgeInsetsGeometry _padding;

  /// Sets the alignment to a new value, and triggers a layout update.
  set padding(EdgeInsetsGeometry value) {
    if (_padding == value) {
      return;
    }
    _padding = value;
    _resolvedPadding = null;
    markNeedsLayout();
  }

  /// The [EdgeInsets] to use for aligning the child.
  ///
  /// This is the [padding] resolved against [textDirection]. Subclasses should
  /// use [resolvedAlignment] instead of [alignment] directly, for computing the
  /// child's offset.
  ///
  /// The [performLayout] method will be called when the value changes.
  EdgeInsets get resolvedPadding => _resolvedPadding ??= padding.resolve(textDirection);
  EdgeInsets? _resolvedPadding;

  /// The [Alignment] to use for aligning the box child.
  ///
  /// This is the [alignment] resolved against [textDirection]. Subclasses should
  /// use [resolvedAlignment] instead of [alignment] directly, for computing the
  /// child's offset.
  ///
  /// The [performLayout] method will be called when the value changes.
  Alignment get resolvedAlignment => _resolvedAlignment ??= alignment.resolve(textDirection);
  Alignment? _resolvedAlignment;

  /// How to align the box child.
  ///
  /// The x and y values of the alignment control the horizontal and vertical
  /// alignment, respectively. An x value of -1.0 means that the left edge of
  /// the child is aligned with the left edge of the parent whereas an x value
  /// of 1.0 means that the right edge of the child is aligned with the right
  /// edge of the parent. Other values interpolate (and extrapolate) linearly.
  /// For example, a value of 0.0 means that the center of the child is aligned
  /// with the center of the parent.
  ///
  /// If this is set to an [AlignmentDirectional] object, then
  /// [textDirection] must not be null.
  AlignmentGeometry get alignment => _alignment;
  AlignmentGeometry _alignment;

  /// Sets the alignment to a new value, and triggers a layout update.
  set alignment(AlignmentGeometry value) {
    if (_alignment == value) {
      return;
    }
    _alignment = value;
    _resolvedAlignment = null;
    markNeedsLayout();
  }

  Offset _boxOffset = Offset.zero;

  /// The text direction with which to resolve [alignment] and [padding].
  ///
  /// This may be changed to null, but only after [alignment] and [padding] has been changed
  /// to a value that does not depend on the direction.
  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;

  set textDirection(TextDirection? value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    _resolvedAlignment = null;
    _resolvedPadding = null;
    markNeedsLayout();
  }

  _RenderSliverAlignBox({
    required TextDirection? textDirection,
    required EdgeInsetsGeometry padding,
    required AlignmentGeometry alignment,
  })  : _alignment = alignment,
        _padding = padding,
        _textDirection = textDirection;

  // Slot getters for accessing child render objects.
  RenderBox? get box => childForSlot(_SliverAlignWidgets.child) as RenderBox?;

  RenderSliver? get sliver => childForSlot(_SliverAlignWidgets.sliver) as RenderSliver?;

  // The returned list is ordered for hit testing.
  @override
  Iterable<RenderObject> get children {
    final _box = box;
    final _sliver = sliver;

    return <RenderObject>[
      if (_sliver != null) _sliver,
      if (_box != null) _box,
    ];
  }

  @override
  void performLayout() {
    final _box = box;
    final _sliver = sliver;

    double childExtent = 0.0;

    if (_sliver != null) {
      _sliver.layout(constraints, parentUsesSize: true);
      childExtent = _sliver.geometry!.scrollExtent;
    }

    if (_box != null) {
      final mainAxisTotalOffset = resolvedPadding.along(constraints.axis);
      final crossAxisTotalOffset = resolvedPadding.along(axisDirectionToAxis(constraints.crossAxisDirection));
      final boxConstraints = constraints
          .asBoxConstraints(
            maxExtent: max(0.0, constraints.viewportMainAxisExtent - mainAxisTotalOffset),
            crossAxisExtent: max(0.0, constraints.crossAxisExtent - crossAxisTotalOffset),
          )
          .copyWith(minHeight: 0, minWidth: 0);
      _box.layout(boxConstraints, parentUsesSize: true);
      final alongOffset = resolvedAlignment.alongOffset(
        boxConstraints.biggest - _box.size as Offset,
      );

      final paddingOffset = Offset(
        max(0, resolvedPadding.left - resolvedPadding.right),
        max(0, resolvedPadding.top - resolvedPadding.bottom),
      );

      _boxOffset = alongOffset + paddingOffset;
    }

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: childExtent.clamp(0.0, constraints.remainingPaintExtent),
      maxPaintExtent: childExtent,
      hitTestExtent: constraints.viewportMainAxisExtent,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final _box = box;
    final _sliver = sliver;

    if (_sliver != null) {
      context.paintChild(_sliver, offset);
    }

    if (_box != null) {
      context.paintChild(_box, offset + _boxOffset);
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData) {
      child.parentData = SliverPhysicalParentData();
    }
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    if (child is RenderBox) {
      return applyPaintTransformForBoxChild(child, transform);
    }
    (child.parentData! as SliverPhysicalParentData).applyPaintTransform(transform);
  }

  @override
  double childMainAxisPosition(RenderBox child) => 0.0;

  @override
  bool hitTestChildren(SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    final _box = box;
    final _sliver = sliver;

    if (_box != null) {
      final mainAxisPositionForBox = mainAxisPosition - _boxOffset.dy;
      final crossAxisPositionForBox = crossAxisPosition - _boxOffset.dx;
      final isHit = hitTestBoxChild(
        BoxHitTestResult.wrap(result),
        _box,
        mainAxisPosition: mainAxisPositionForBox,
        crossAxisPosition: crossAxisPositionForBox,
      );

      if (isHit) {
        return true;
      }
    }

    if (_sliver != null) {
      return _sliver.hitTest(result,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition,
      );
    }

    return false;
  }
}
