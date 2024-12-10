import 'package:auto_route/auto_route.dart';

extension PoiCardHandlerStack on StackRouter {
  /// [route] - new route to push
  /// [toCompareRoutes] - list of route names to compare with current active route and if any of them is active,
  /// then pop it and push the new route
  Future<void> replaceOrPush({
    required PageRouteInfo route,
    required List<String> toCompareRoutes,
  }) async {
    if (toCompareRoutes.where((e) => isRouteActive(e)).isNotEmpty) {
      await replace(route);
    } else {
      await push(route);
    }
  }
}
