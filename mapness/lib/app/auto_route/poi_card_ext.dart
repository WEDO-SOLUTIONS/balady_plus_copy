import 'package:auto_route/auto_route.dart';

extension PoiCardHandlerStack on StackRouter {
  /// [route] - new route to push
  /// [toCompareRoutes] - list of route names to compare with current active route and if any of them is active,
  /// then pop it and push the new route
  Future<void> replaceOrPush({
    required PageRouteInfo route,
    required List<PageInfo> toCompareRoutes,
  }) async {
    if (toCompareRoutes.any((e) => isRouteActive(e.name))) {
      // Use popAndPush to properly close the current route and open the new one
      // This ensures the widget rebuilds with new parameters
      await popAndPush(route);
    } else {
      await push(route);
    }
  }
}
