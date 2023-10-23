import 'dart:async';

import 'package:dgis_map/library.dart';
// import 'package:dgis_map_example/nav/controls/dashboard/dashboard_control.dart';
import 'package:flutter/material.dart';
import 'package:mapness/legacy/navigation_dashboard/dashboard_control.dart';

///
class NavViewModel {
  ///
  NavViewModel(
    this.mapController, {
    this.freeRoamDefault = false,
  });

  ///
  final DgisMapController mapController;
  final bool freeRoamDefault;

  ///
  late final DashboardControlController dashboardControlController;
  late final StreamSubscription<NavigationEvent> navigationSubscription;
  final navSoundsState = ValueNotifier<bool>(true);
  late final ValueNotifier<bool> isFreeRoam = ValueNotifier(freeRoamDefault);
  late final StreamSubscription<RouteOptionsEvent> routeOptionsSubscription;

  NaviSpeedController get speedController => mapController.naviSpeedController;

  Stream<RouteChangedEvent> get routeChangedEvents =>
      mapController.routeChangedEvents;

  NaviManeuverController get maneuverController =>
      mapController.naviManeuverController;

  NaviZoomController get zoomController => mapController.naviZoomController;

  NaviMessageController get messageController =>
      mapController.naviMessageController;

  NaviCompassController get compassController =>
      mapController.naviCompassController;

  NaviTrafficParkingController get trafficParkingController =>
      mapController.naviTrafficParkingController;

  Stream<NaviDashboardEvent> get dashboardControlEvents =>
      mapController.naviDashboardEvents;

  NavigationEvent? _state;
  bool _routeHasOptions = false;

  void init() {
    final List<GlobalKey<State<StatefulWidget>>> sheetKeys =
        List.generate(3, (index) => GlobalKey<State<StatefulWidget>>());
    dashboardControlController =
        DashboardControlController.withSheetKeys(sheetKeys);
    navigationSubscription = mapController.navigationEvents.listen((event) {
      if (event == NavigationEvent.finished) {
        unawaited(
            dashboardControlController.showResultBottomSheet(closable: false));
      }
      _state = event;
    });

    routeOptionsSubscription = mapController.routeOptionEvents.listen((event) {
      _routeHasOptions = event.hasOptions;
    });
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  void dispose() {
    unawaited(navigationSubscription.cancel());
    unawaited(routeOptionsSubscription.cancel());
  }

  void setFreeRoam() => isFreeRoam.value = (_state == NavigationEvent.disabled)
      ? freeRoamDefault
      : !_routeHasOptions;

  void onSoundTap() {
    navSoundsState.value = !navSoundsState.value;
    unawaited(mapController.toggleSound());
  }
}
