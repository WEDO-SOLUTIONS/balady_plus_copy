import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:mapness/shared/providers/top_route_name_notifier.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

class RoutesObserver extends AutoRouteObserver {
  final WidgetRef ref;

  RoutesObserver({required this.ref});

  TopRouteName get _topRouteNameNotifier => ref.read(topRouteNameProvider.notifier);

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    final analytics = ref.read(urbiAnalyticsProvider);
    _topRouteNameNotifier.setRoute(route.settings.name);

    if (route.settings is AutoRoutePage && previousRoute?.settings is AutoRoutePage) {
      final path = (route.settings as AutoRoutePage).routeData.path;

      final currentPath = path.startsWith('/') ? path : '/$path';
      BaladyAnalytics.instance.screen(currentPath);
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
    _topRouteNameNotifier.setRoute(previousRoute?.settings.name);
    logger.log('Current Screen pop: ${route.settings.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    super.didChangeTabRoute(route, previousRoute);

    final path = route.path.startsWith('/') ? route.path : '/${route.path}';
    BaladyAnalytics.instance.screen(path);
    ref.read(urbiAnalyticsProvider).screen(path);
    logger.log('Tab changed: ${route.name}');
  }
}
