import 'package:flutter/widgets.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';

/// Screen-view tagging for the host shell's classic navigator — replaces
/// `FlutterUxcamNavigatorObserver`. The mapness auto_route stack has its own
/// `RoutesObserver` doing the same.
class BaladyAnalyticsNavigatorObserver extends NavigatorObserver {
  void _tag(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name != null && name.isNotEmpty) {
      BaladyAnalytics.instance.screen(name);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _tag(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _tag(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _tag(newRoute);
  }
}
