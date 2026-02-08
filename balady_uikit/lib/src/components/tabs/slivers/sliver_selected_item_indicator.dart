import 'package:balady_uikit/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverSelectedItemIndicator extends SingleChildRenderObjectWidget {
  final SymmetricScrollController? controller;
  final Decoration? indicator;

  const SliverSelectedItemIndicator({
    Widget? sliver,
    this.controller,
    this.indicator,
    super.key,
  }) : super(child: sliver);

  @override
  _RenderSliverIndicator createRenderObject(BuildContext context) => _RenderSliverIndicator(
        controller: controller,
        indicator: indicator,
      );

  @override
  void updateRenderObject(BuildContext context, _RenderSliverIndicator renderObject) =>
      renderObject.updateController(controller, indicator);
}

class _RenderSliverIndicator extends RenderProxySliver {
  SymmetricScrollController? controller;
  Decoration? indicator;

  Rect? _currentRect;
  Rect? _interpolationFromRect;
  Rect? _interpolationToRect;

  BoxPainter? _painter;

  _RenderSliverIndicator({
    this.controller,
    this.indicator,
    RenderSliver? sliver,
  }) {
    child = sliver;
  }

  @override
  bool get isRepaintBoundary => child != null;

  void updateController(SymmetricScrollController? tabController, Decoration? indicator) {
    controller?.animation?.removeListener(_updateIndicator);
    controller = tabController;
    controller?.animation?.addListener(_updateIndicator);
    this.indicator = indicator;
    _lastCalculatedFrom = -1;
    _lastCalculatedTo = -1;
    _updateIndicator();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    controller?.animation?.addListener(_updateIndicator);
    _updateIndicator(); // in case it changed while we weren't listening
  }

  @override
  void detach() {
    controller?.animation?.removeListener(_updateIndicator);
    super.detach();
  }

  @override
  void dispose() {
    super.dispose();
    _painter?.dispose();
  }

  void _updateIndicator() {
    if (controller?.animation?.value != _indicatorValue) {
      _indicatorIndex = controller?.index.toDouble() ?? 0;
      _indicatorValue = controller?.animation?.value ?? 0;

      markNeedsPaint();
    }
  }

  double _indicatorValue = 0.0;
  double _indicatorIndex = 0.0;

  int _lastCalculatedFrom = -1;
  int _lastCalculatedTo = -1;

  double _lastPaintExtent = 0.0;

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);

    final _indicator = indicator;
    final _controller = controller;
    final _child = child;

    // If no indicator or controller provided and child is not a custom render sliver list, do nothing.
    if (_indicator == null || _controller == null || _child is! RenderSliverSymmetricExpandableList) {
      return;
    }

    final ltr = constraints.axisDirection == AxisDirection.right || constraints.axisDirection == AxisDirection.down;

    final maxTabIndex = _child.childCount - 1;
    final scrollOffset = Offset(
      ltr ? -constraints.scrollOffset : constraints.scrollOffset,
      0,
    );

    // Calculates indexs of children's render boxes to interpolate to.
    final double index = _indicatorIndex;
    final double value = _indicatorValue;
    final bool moveLTR = index > value;
    final int from = (moveLTR ? value.floor() : value.ceil()).clamp(0, maxTabIndex);
    final int to = (moveLTR ? from + 1 : from - 1).clamp(0, maxTabIndex);

    // If render boxes on which identicator size depends change. Update it.
    if (!ltr && _lastPaintExtent != geometry!.paintExtent || to != _lastCalculatedTo || from != _lastCalculatedFrom) {
      _lastPaintExtent = geometry!.paintExtent;
      _lastCalculatedFrom = from;
      _lastCalculatedTo = to;
      final boxes = _child.getRectangleBoxes(from, to);
      _interpolationFromRect = boxes.$1;
      _interpolationToRect = boxes.$2;
    }

    // Linearly interpolate between from render box and to new render box.
    _currentRect = Rect.lerp(_interpolationFromRect, _interpolationToRect, (value - from).abs());

    // Shift indicator position based on scroll offset.
    _currentRect = _currentRect?.shift(scrollOffset);

    _painter ??= _indicator.createBoxPainter(markNeedsPaint);
    final ImageConfiguration configuration = ImageConfiguration(
      size: _currentRect!.size,
      textDirection: ltr ? TextDirection.ltr : TextDirection.rtl,
    );
    _painter?.paint(context.canvas, _currentRect!.topLeft, configuration);
  }
}
