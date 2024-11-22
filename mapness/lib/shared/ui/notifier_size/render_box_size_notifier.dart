import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapness/shared/ui/notifier_size/size_widget_notifier.dart';

/// The render object that reports its size to the notification system.
class RenderBoxSizeNotifier extends RenderProxyBox {
  RenderBoxSizeNotifier({
    required BuildContext context,
    RenderBox? child,
  })  : _context = context,
        super(child);

  /// Required to access the [BuildContext] to dispatch the notification.
  final BuildContext _context;

  /// The previous size of the child.
  Size? _oldSize;

  @override
  void performLayout() {
    /// Takes care of laying out the child and making sure its size is usable.
    super.performLayout();

    final newSize = child!.size;

    /// Only dispatch the notification if the size has changed.
    if (_oldSize != newSize) {
      _oldSize = newSize;
      SizeWidgetNotification(newSize).dispatch(_context);
    }
  }
}
