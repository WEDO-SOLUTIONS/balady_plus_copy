import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(
    this.onChange,
  );

  @override
  void performLayout() {
    super.performLayout();

    if (oldSize == size) {
      return;
    }

    oldSize = size;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (attached) {
        onChange(size);
      }
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    required this.onChange,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) => MeasureSizeRenderObject(onChange);

  @override
  void updateRenderObject(BuildContext context, covariant MeasureSizeRenderObject renderObject) {
    // Only the callback is swapped here. This used to call `markNeedsLayout()`
    // unconditionally, forcing a relayout of this subtree on *every* rebuild of
    // the parent even when nothing about the size could have changed - and
    // marking layout dirty from `updateRenderObject` is exactly the kind of
    // out-of-turn dirtying that breaks under a LayoutBuilder.
    renderObject.onChange = onChange;
  }
}
