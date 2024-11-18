import 'package:auto_route/auto_route.dart';

final class PoiRouteGuard extends AutoRouteGuard {
  const PoiRouteGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (router.current.name == resolver.route.name && router.canPop()) {
      router.maybePop();
    }

    resolver.next();
  }
}
