import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A sliver that fills the remaining space after another sliver.
///
/// This widget ensures that if the child sliver's height is smaller than the
/// left viewport height, it expands to fill the remaining space. If the child's
/// height exceeds the viewport, it sizes itself to the child's height.
///
/// Also, it is a good practice to use this widget as the last child in a
/// [CustomScrollView] to ensure it fills the remaining space.
class SliverFillAfter extends SingleChildRenderObjectWidget {
  const SliverFillAfter({required Widget sliver, Key? key}) : super(key: key, child: sliver);

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSliverFillRemaidAfterSliver();
}

class _RenderSliverFillRemaidAfterSliver extends RenderProxySliver with RenderSliverHelpers {
  _RenderSliverFillRemaidAfterSliver();

  @override
  void performLayout() {
    final double viewportHeightLeft = constraints.remainingPaintExtent;
    double childExtent = 0.0;

    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      childExtent = child!.geometry!.scrollExtent;
    }

    final double effectiveHeight = childExtent > viewportHeightLeft ? childExtent : viewportHeightLeft;
    geometry = SliverGeometry(
      scrollExtent: effectiveHeight,
      paintExtent: effectiveHeight.clamp(0.0, constraints.remainingPaintExtent),
      maxPaintExtent: effectiveHeight,
    );
  }
}
