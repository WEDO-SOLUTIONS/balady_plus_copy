import 'package:auto_route/auto_route.dart';
import 'package:mapness/app/auto_route/app_routes.dart';

extension PoiCardHandler on AppRouter {
  void replaceOrPush<T extends PageRouteInfo>(PageRouteInfo route) {
    if (current is T) {
      replace(route);
    } else {
      push(route);
    }
  }
}
