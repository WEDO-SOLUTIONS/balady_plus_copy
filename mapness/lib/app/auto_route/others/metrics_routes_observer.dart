import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/metrics/events/metrics_event.dart';
import 'package:mapness/shared/providers/metrics/metrics_route_flow_manager.dart';

class MetricsRoutesObserver extends AutoRouteObserver {
  final WidgetRef ref;

  MetricsRoutesObserver({required this.ref});

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _handleRoute(route, MetricsRouteOperation.push);
  }

  void _handleRoute(Route route, MetricsRouteOperation operation) {
    if (route.settings is AutoRoutePage) {
      final pageRouteInfo = (route.settings as AutoRoutePage).routeData.route.toPageRouteInfo();
      // used addPostFrameCallback because of error of mutating state during navigation initialization
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(metricsRouteFlowManagerProvider.notifier)
            .pushItem(
              MetricsRouteFlowItem(
                route: pageRouteInfo,
                operation: operation,
              ),
            );
      });
    } else {
      // TODO(metrics): do we need to handle this case?
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _handleRoute(route, MetricsRouteOperation.pop);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _handleRoute(newRoute, MetricsRouteOperation.replace);
    }
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    super.didChangeTabRoute(route, previousRoute);
    final pageRouteInfo = route.routeInfo.toPageRouteInfo();
    final flowManager = ref
        .read(metricsRouteFlowManagerProvider.notifier)
        .pushItem(
          MetricsRouteFlowItem(
            route: pageRouteInfo,
            operation: MetricsRouteOperation.changeTab,
          ),
        );
  }
}
