import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/notifier_size/render_box_size_notifier.dart';

/// A widget that reports its child's size to the notification system.
class SizeReporter extends SingleChildRenderObjectWidget {
  const SizeReporter({required super.child, super.key});

  @override
  RenderObject createRenderObject(BuildContext context) => RenderBoxSizeNotifier(context: context);
}