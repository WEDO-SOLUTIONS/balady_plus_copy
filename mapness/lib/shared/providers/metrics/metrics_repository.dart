import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/metrics/events/metrics_event.dart';
import 'package:mapness/entities/metrics/metrics_data_source.dart';
import 'package:mapness/shared/providers/metrics/sources/byte_dance_metrics_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'metrics_route_flow_manager.dart';

part 'metrics_repository.g.dart';

@Riverpod(keepAlive: true)
class MetricsRepository extends _$MetricsRepository {
  late final List<MetricsDataSource> _dataSources;

  @override
  void build() {
    _dataSources = [
      ByteDanceMetricsDataSource(),
    ];
  }

  Future<void> sendEvent(MetricsEvent event) => Future.wait(_dataSources.map((e) => e.sendEvent(event)));

  Future<void> sendQuickSearchClickEvent(String searchText) async {
    ref.read(appRouterProvider).topMostRouter().stackData.map((e) => e.name).toList();
    final routeStack = ref.read(appRouterProvider).topMostRouter().stackData;
    for (final route in routeStack) {
      debugPrint('route is: $route');
    }
    /*
    todo remove
ref.read(appRouterProvider).topMostRouter().stackData.map((e) => e.name).toList()
case 1:
0 = "BottomMenuRoute"
1 = "PathNavRoute"
2 = "NaviSearchRoute"


case 2:
0 = "BottomMenuRoute"
1 = "PoiCardWidgetRoute"
2 = "RoutingRoutesRoute"

case 3:
0 = "BottomMenuRoute"
1 = "PathNavRoute"
2 = "NaviSearchRoute"

case 4:
0 = "BottomMenuRoute"
1 = "FreeRoamRoute"
2 = "NaviSearchRoute"

case 5:
0 = "BottomMenuRoute"
1 = "FreeRoamRoute"
2 = "NaviSearchRoute"

case 6.1:
0 = "LandingRoute"
1 = "RoutingPointsRoute" - when switching Tab to "Routes"
2 = "MapnessServicesRoute"
3 = ""

case 6.2:
0 = "BottomMenuRoute"
1 = "PathNavRoute"
2 = "NaviSearchRoute"

case 7.1:
0 = "LandingRoute"
1 = "RoutingPointsRoute" - when switching Tab to "Routes"
2 = "MapnessServicesRoute"
3 = ""

case 7.2:
0 = "BottomMenuRoute"
1 = "PathNavRoute"
2 = "NaviSearchRoute"
     */

    // todo get event from router
    final routesSet = routeStack.map((e) => e.name).toSet();
    MetricsFavouriteQuickSearchClickEventSource? eventSource;
    if (routesSet.contains(NaviSearchRoute.name)) {
      eventSource = MetricsFavouriteQuickSearchClickEventSource.exploreDirection;
    }

    final metricsRouteFlow = ref.read(metricsRouteFlowManagerProvider);
    final containsMapMainPage = metricsRouteFlow.containsRouteSequence(
      MetricsRouteFlowSequence.mapMainPage,
    );

    if (containsMapMainPage) {
      eventSource = MetricsFavouriteQuickSearchClickEventSource.exploreDirection;
    }

    if (eventSource == null) {
      // todo log error
      return;
    }

    await sendEvent(MetricsEvent.quickSearchClick(eventSource: eventSource, searchText: searchText));
  }
}
