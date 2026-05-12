import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:urbi_analytics/analytics.dart' show Analytics;

class RoutesObserver extends AutoRouteObserver {
  final Analytics analytics;

  RoutesObserver({required this.analytics});

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    if (route.settings is AutoRoutePage && previousRoute?.settings is AutoRoutePage) {
      final path = (route.settings as AutoRoutePage).routeData.path;

      final currentPath = path.startsWith('/') ? path : '/$path';
      FlutterUxcam.tagScreenName(currentPath);
      analytics.screen(currentPath);
      logger.log('New route pushed: $currentPath');
    } else {
      final name = route.settings.name;
      analytics.screen(name ?? 'Unknown');
      logger.log('New route pushed: $name');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    logger.log('Current Screen pop: ${route.settings.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    super.didChangeTabRoute(route, previousRoute);

    final path = route.path.startsWith('/') ? route.path : '/${route.path}';
    FlutterUxcam.tagScreenName(path);
    analytics.screen(path);
    logger.log('Tab changed: ${route.name}');
  }
}
