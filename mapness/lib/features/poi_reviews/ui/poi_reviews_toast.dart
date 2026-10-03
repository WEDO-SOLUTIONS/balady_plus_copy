import 'package:balady_uikit/balady_uikit.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/poi_reviews/ui/poi_rated_toast.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

/// The POI card and its sheets aren't below [ToastOverlay]; the root navigator is. Does nothing if unavailable.
/// Its context has no ThemeController above it: resolve colours and texts in the caller's context beforehand.
void showRootToast(void Function(ToastOverlayState toast) show) {
  final toast = rootNavigatorKey.currentContext?.findAncestorStateOfType<ToastOverlayState>();
  if (toast != null) {
    show(toast);
  }
}

void showPoiRatedToast(PoiRatedToast data) => showRootToast(
  (toast) => toast.show(
    title: data.title,
    icon: ToastIconData(General16Icons.starSolid, color: data.starColor),
    actions: [ToastAction(title: data.closeLabel)],
    displayDuration: const Duration(seconds: 4),
  ),
);
