import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';

class RoutesObserver extends AutoRouterObserver {
  final WidgetRef ref;

  RoutesObserver({required this.ref});

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    final analytics = ref.read(urbiAnalyticsProvider);

    if (route.settings is AutoRoutePage && previousRoute?.settings is AutoRoutePage) {
      final path = (route.settings as AutoRoutePage).routeData.path;

      final currentPath = path.startsWith('/') ? path : '/$path';
      FlutterUxcam.tagScreenName(currentPath);
      analytics.screen(currentPath);
      debugPrint('New route pushed: $currentPath');
    } else {
      final name = route.settings.name;
      analytics.screen(name ?? 'Unknown');
      debugPrint('New route pushed: $name');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    debugPrint('Current Screen pop: ${route.settings.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    super.didChangeTabRoute(route, previousRoute);

    final path = route.path.startsWith('/') ? route.path : '/${route.path}';
    FlutterUxcam.tagScreenName(path);
    ref.read(urbiAnalyticsProvider).screen(path);
    debugPrint('Tab changed: ${route.name}');
  }
}
