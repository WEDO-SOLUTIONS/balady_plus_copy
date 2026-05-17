import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Виджет который нотифицирует об изменении [child] [Size]
class WidgetSizeNotifier extends SingleChildRenderObjectWidget {
  const WidgetSizeNotifier({
    required this.onSizeChanged,
    required Widget super.child,
    super.key,
  });
  final ValueChanged<Size> onSizeChanged;

  @override
  DgisRenderWidgetSizeNotifier createRenderObject(BuildContext context) => DgisRenderWidgetSizeNotifier(onSizeChanged);
}

class DgisRenderWidgetSizeNotifier extends RenderProxyBox {
  DgisRenderWidgetSizeNotifier(
    this.onSizeChanged, {
    RenderBox? child,
  }) : super(child);

  final ValueChanged<Size> onSizeChanged;

  Size _oldSize = Size.zero;

  @override
  void performLayout() {
    super.performLayout();
    if (_oldSize != size) {
      _oldSize = size;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (attached) {
            onSizeChanged(_oldSize);
          }
        },
      );
    }
  }
}
