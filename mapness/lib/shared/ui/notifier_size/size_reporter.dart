import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/notifier_size/render_box_size_notifier.dart';

/// A widget that reports size changes of its child to the notification system.
///
/// This widget wraps another widget (the `child`) and uses a custom
/// [RenderObject], [RenderBoxSizeNotifier], to monitor its size.
/// When the size changes, it sends a [SizeWidgetNotification] to the widget tree.
class SizeReporter extends SingleChildRenderObjectWidget {
  /// Creates a [SizeReporter] with the specified [child].
  const SizeReporter({required super.child, super.key});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderBoxSizeNotifier(context: context);
}
