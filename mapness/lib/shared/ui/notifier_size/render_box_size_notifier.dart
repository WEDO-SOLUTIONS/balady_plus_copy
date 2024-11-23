import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapness/shared/ui/notifier_size/size_widget_notifier.dart';

/// A custom RenderObject that tracks the size of its child and notifies
/// the widget tree whenever the size changes.
///
/// This class extends [RenderProxyBox] and overrides the layout process
/// to compare the current size of the child with the previously recorded size.
/// If a size change is detected, it dispatches a [SizeWidgetNotification]
/// with the new size.
class RenderBoxSizeNotifier extends RenderProxyBox {
  /// Creates a [RenderBoxSizeNotifier] that monitors its child's size.
  ///
  /// [context] is required to dispatch the [SizeWidgetNotification].
  RenderBoxSizeNotifier({
    required BuildContext context,
    RenderBox? child,
  })  : _context = context,
        super(child);

  /// The [BuildContext] used to dispatch notifications.
  final BuildContext _context;

  /// Stores the previous size of the child for comparison.
  Size? _oldSize;

  @override
  void performLayout() {
    // Perform the layout for the child.
    super.performLayout();

    // Get the new size of the child.
    final newSize = child!.size;

    // If the size has changed, update _oldSize and dispatch a notification.
    if (_oldSize != newSize) {
      _oldSize = newSize;
      SizeWidgetNotification(newSize).dispatch(_context);
    }
  }
}
