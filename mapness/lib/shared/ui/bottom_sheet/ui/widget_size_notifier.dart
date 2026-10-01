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

  // Set when a size change is observed and cleared once `onSizeChanged` is
  // actually delivered. If this render object gets detached in the single
  // frame between scheduling the post-frame callback and it running (BE-88:
  // observed racing a sibling sheet's keyboard-inset settle animation), the
  // callback silently no-ops on `attached` and — since `_oldSize` is already
  // updated — a later `performLayout` may never see a differing size again,
  // permanently losing the notification. Re-attaching must redeliver it.
  bool _pendingNotify = false;

  void _scheduleNotify() {
    _pendingNotify = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (attached && _pendingNotify) {
        _pendingNotify = false;
        onSizeChanged(_oldSize);
      }
    });
  }

  @override
  void performLayout() {
    super.performLayout();
    if (_oldSize != size) {
      _oldSize = size;
      _scheduleNotify();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_pendingNotify) {
      _scheduleNotify();
    }
  }
}
