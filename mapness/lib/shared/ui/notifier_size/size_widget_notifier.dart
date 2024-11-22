import 'package:flutter/material.dart';

/// Extends from Notification.
class SizeWidgetNotification extends Notification {
  const SizeWidgetNotification(this.size);

  /// Notification data.
  final Size size;
}