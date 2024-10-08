import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';

class RoutesObserver extends AutoRouterObserver {
  final WidgetRef ref;

  RoutesObserver({required this.ref});

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    final currentPath = route.settings.name ?? 'Unknown';
    ref.read(urbiAnalyticsProvider).screen(currentPath);
    debugPrint('New route pushed: $currentPath');
  }
}
