import 'package:flutter/material.dart';

/// A notification that carries information about the size of a widget.
///
/// This class extends [Notification] and is used by [RenderBoxSizeNotifier]
/// to send size change events up the widget tree.
class SizeWidgetNotification extends Notification {
  /// Creates a [SizeWidgetNotification] with the given [size].
  const SizeWidgetNotification(this.size);

  /// The new size of the widget that triggered this notification.
  final Size size;
}
