import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

/// The POI card and its sheets aren't below [ToastOverlay]; the root navigator is. Does nothing if unavailable.
void showRootToast(void Function(ToastOverlayState toast, BuildContext context) show) {
  final context = rootNavigatorKey.currentContext;
  final toast = context?.findAncestorStateOfType<ToastOverlayState>();
  if (context != null && toast != null) {
    show(toast, context);
  }
}
