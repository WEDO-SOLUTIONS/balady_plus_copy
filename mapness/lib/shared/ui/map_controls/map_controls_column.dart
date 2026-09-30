import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Where a [MapControlsItem] is anchored inside a [MapControlsColumn].
enum MapControlsSlot {
  /// Stacked from the top edge downwards.
  top,

  /// Centred in the column, kept between the [top] and [bottom] groups.
  center,

  /// Stacked from the bottom edge upwards.
  bottom,
}

/// A vertical stack of map controls that never overflows.
///
/// Sheets give their `outside` slot a tight height that shrinks as the sheet grows, so a plain [Column] of
/// fixed-size buttons overflows once the sheet is tall enough. This column instead keeps as many controls as fit,
/// dropping the ones with the lowest [MapControlsItem.priority] first. A control that is about to be dropped fades
/// out over [fadeExtent] pixels of remaining space, so dragging a sheet hides the buttons smoothly one by one.
///
/// Children that lay out with zero height (a control that is currently hidden and returns
/// `SizedBox.shrink()`) take no space and get no [spacing] around them.
///
/// Dropped children stay mounted — only their paint, hit testing and semantics are skipped — so their state
/// (animations, provider listeners) survives the sheet moving back down.
class MapControlsColumn extends MultiChildRenderObjectWidget {
  const MapControlsColumn({
    required super.children,
    this.spacing = 8,
    this.fadeExtent = 24,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textDirection,
    super.key,
  }) : assert(
         crossAxisAlignment == CrossAxisAlignment.start ||
             crossAxisAlignment == CrossAxisAlignment.center ||
             crossAxisAlignment == CrossAxisAlignment.end,
         'Only start, center and end are supported',
       );

  /// Gap between two visible controls. Also the minimum gap kept between the slot groups.
  final double spacing;

  /// Remaining free space below which the next control to be dropped starts fading out.
  final double fadeExtent;

  final CrossAxisAlignment crossAxisAlignment;

  /// Resolves [CrossAxisAlignment.start]/[CrossAxisAlignment.end]. Defaults to the ambient [Directionality].
  final TextDirection? textDirection;

  @override
  RenderMapControlsColumn createRenderObject(BuildContext context) => RenderMapControlsColumn(
    spacing: spacing,
    fadeExtent: fadeExtent,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: textDirection ?? Directionality.maybeOf(context) ?? TextDirection.ltr,
  );

  @override
  void updateRenderObject(BuildContext context, RenderMapControlsColumn renderObject) {
    renderObject
      ..spacing = spacing
      ..fadeExtent = fadeExtent
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = textDirection ?? Directionality.maybeOf(context) ?? TextDirection.ltr;
  }
}

/// Configures how a child of [MapControlsColumn] is placed and when it is dropped.
class MapControlsItem extends ParentDataWidget<MapControlsParentData> {
  const MapControlsItem({
    required this.priority,
    required super.child,
    this.slot = MapControlsSlot.top,
    super.key,
  });

  /// Higher priority controls are kept longer when space runs out.
  final int priority;

  final MapControlsSlot slot;

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData! as MapControlsParentData;
    if (parentData.priority != priority || parentData.slot != slot) {
      parentData
        ..priority = priority
        ..slot = slot;
      renderObject.parent?.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => MapControlsColumn;
}

class MapControlsParentData extends ContainerBoxParentData<RenderBox> {
  int priority = 0;
  MapControlsSlot slot = MapControlsSlot.top;

  /// Whether the child fitted during the last layout. Dropped children are not painted, hit tested or read out.
  bool _isVisible = true;

  /// Opacity resolved during the last layout, lower while the child is about to be dropped.
  double _opacity = 1;

  final LayerHandle<OpacityLayer> _opacityLayer = LayerHandle<OpacityLayer>();
}

class RenderMapControlsColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MapControlsParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MapControlsParentData> {
  RenderMapControlsColumn({
    required double spacing,
    required double fadeExtent,
    required CrossAxisAlignment crossAxisAlignment,
    required TextDirection textDirection,
  }) : _spacing = spacing,
       _fadeExtent = fadeExtent,
       _crossAxisAlignment = crossAxisAlignment,
       _textDirection = textDirection;

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) {
      return;
    }
    _spacing = value;
    markNeedsLayout();
  }

  double _fadeExtent;
  double get fadeExtent => _fadeExtent;
  set fadeExtent(double value) {
    if (_fadeExtent == value) {
      return;
    }
    _fadeExtent = value;
    markNeedsLayout();
  }

  CrossAxisAlignment _crossAxisAlignment;
  CrossAxisAlignment get crossAxisAlignment => _crossAxisAlignment;
  set crossAxisAlignment(CrossAxisAlignment value) {
    if (_crossAxisAlignment == value) {
      return;
    }
    _crossAxisAlignment = value;
    markNeedsLayout();
  }

  TextDirection _textDirection;
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  bool _hasFadingChild = false;

  /// Which children were visible after the last layout; a change alters the semantics tree (dropped children are not
  /// visited for semantics), so it has to be rebuilt.
  List<bool> _visibility = const [];

  @override
  bool get alwaysNeedsCompositing => _hasFadingChild;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MapControlsParentData) {
      child.parentData = MapControlsParentData();
    }
  }

  List<RenderBox> get _children {
    final result = <RenderBox>[];
    var child = firstChild;
    while (child != null) {
      result.add(child);
      child = childAfter(child);
    }
    return result;
  }

  static MapControlsParentData _data(RenderBox child) => child.parentData! as MapControlsParentData;

  BoxConstraints _childConstraints(BoxConstraints constraints) => BoxConstraints(maxWidth: constraints.maxWidth);

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final childConstraints = _childConstraints(constraints);
    var width = 0.0;
    var height = 0.0;
    var visibleCount = 0;
    for (final child in _children) {
      final size = child.getDryLayout(childConstraints);
      width = math.max(width, size.width);
      if (size.height > 0) {
        height += size.height + (visibleCount > 0 ? spacing : 0);
        visibleCount++;
      }
    }
    return constraints.constrain(Size(width, constraints.hasBoundedHeight ? constraints.maxHeight : height));
  }

  @override
  void performLayout() {
    final childConstraints = _childConstraints(constraints);
    final children = _children;

    var width = 0.0;
    for (final child in children) {
      child.layout(childConstraints, parentUsesSize: true);
      width = math.max(width, child.size.width);
    }

    // Pick what fits: highest priority first, ties resolved by position so the layout stays predictable.
    final candidates = [
      for (final child in children)
        if (child.size.height > 0) child,
    ];
    final order = [for (var i = 0; i < candidates.length; i++) i]
      ..sort((a, b) {
        final byPriority = _data(candidates[b]).priority.compareTo(_data(candidates[a]).priority);
        return byPriority != 0 ? byPriority : a.compareTo(b);
      });

    final available = constraints.hasBoundedHeight ? constraints.maxHeight : double.infinity;
    var used = 0.0;
    var visibleCount = 0;
    var hasFadingChild = false;
    for (final child in children) {
      _data(child)._isVisible = false;
    }
    for (final index in order) {
      final child = candidates[index];
      final cost = child.size.height + (visibleCount > 0 ? spacing : 0);
      final slack = available - used - cost;
      if (slack < 0) {
        continue;
      }
      final opacity = fadeExtent > 0 ? (slack / fadeExtent).clamp(0.0, 1.0) : 1.0;
      _data(child)
        .._isVisible = true
        .._opacity = opacity;
      hasFadingChild |= opacity < 1;
      used += cost;
      visibleCount++;
    }

    final height = constraints.hasBoundedHeight ? constraints.maxHeight : used;
    size = constraints.constrain(Size(width, height));

    final visible = [
      for (final child in candidates)
        if (_data(child)._isVisible) child,
    ];
    final top = visible.where((c) => _data(c).slot == MapControlsSlot.top).toList();
    final center = visible.where((c) => _data(c).slot == MapControlsSlot.center).toList();
    final bottom = visible.where((c) => _data(c).slot == MapControlsSlot.bottom).toList();

    var y = 0.0;
    for (final child in top) {
      _position(child, y);
      y += child.size.height + spacing;
    }
    final topEnd = top.isEmpty ? 0.0 : y;

    final bottomHeight = _groupHeight(bottom);
    var bottomY = size.height - bottomHeight;
    for (final child in bottom) {
      _position(child, bottomY);
      bottomY += child.size.height + spacing;
    }
    final bottomStart = bottom.isEmpty ? size.height : size.height - bottomHeight - spacing;

    final centerHeight = _groupHeight(center);
    final maxCenterY = bottomStart - centerHeight;
    var centerY = ((size.height - centerHeight) / 2).clamp(topEnd, math.max(topEnd, maxCenterY)).toDouble();
    for (final child in center) {
      _position(child, centerY);
      centerY += child.size.height + spacing;
    }

    final visibility = [for (final child in children) _data(child)._isVisible];
    if (!listEquals(visibility, _visibility)) {
      _visibility = visibility;
      markNeedsSemanticsUpdate();
    }

    if (hasFadingChild != _hasFadingChild) {
      _hasFadingChild = hasFadingChild;
      markNeedsCompositingBitsUpdate();
    }
  }

  double _groupHeight(List<RenderBox> group) {
    if (group.isEmpty) {
      return 0;
    }
    return group.fold<double>(0, (sum, child) => sum + child.size.height) + spacing * (group.length - 1);
  }

  void _position(RenderBox child, double y) {
    final free = size.width - child.size.width;
    final isRtl = textDirection == TextDirection.rtl;
    final x = switch (crossAxisAlignment) {
      CrossAxisAlignment.center => free / 2,
      CrossAxisAlignment.end => isRtl ? 0.0 : free,
      _ => isRtl ? free : 0.0,
    };
    _data(child).offset = Offset(x, y);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in _children) {
      final data = _data(child);
      final alpha = data._isVisible ? (data._opacity * 255).round() : 0;
      if (alpha == 0 || alpha == 255) {
        data._opacityLayer.layer = null;
        if (alpha == 255) {
          context.paintChild(child, data.offset + offset);
        }
        continue;
      }
      data._opacityLayer.layer = context.pushOpacity(
        offset,
        alpha,
        (context, offset) => context.paintChild(child, data.offset + offset),
        oldLayer: data._opacityLayer.layer,
      );
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    var child = lastChild;
    while (child != null) {
      final data = _data(child);
      if (data._isVisible && data._opacity > 0) {
        final isHit = result.addWithPaintOffset(
          offset: data.offset,
          position: position,
          hitTest: (result, transformed) => child!.hitTest(result, position: transformed),
        );
        if (isHit) {
          return true;
        }
      }
      child = data.previousSibling;
    }
    return false;
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    for (final child in _children) {
      if (_data(child)._isVisible) {
        visitor(child);
      }
    }
  }

  @override
  void dispose() {
    for (final child in _children) {
      _data(child)._opacityLayer.layer = null;
    }
    super.dispose();
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _children.fold(0, (width, child) => math.max(width, child.getMinIntrinsicWidth(double.infinity)));

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _children.fold(0, (width, child) => math.max(width, child.getMaxIntrinsicWidth(double.infinity)));

  // Every control can be dropped, so the column fits into any height.
  @override
  double computeMinIntrinsicHeight(double width) => 0;

  @override
  double computeMaxIntrinsicHeight(double width) {
    var height = 0.0;
    var visibleCount = 0;
    for (final child in _children) {
      final childHeight = child.getMaxIntrinsicHeight(width);
      if (childHeight > 0) {
        height += childHeight + (visibleCount > 0 ? spacing : 0);
        visibleCount++;
      }
    }
    return height;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) => null;
}
