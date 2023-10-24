import 'dart:async';

import 'package:dgis_map/library.dart';
// import 'package:dgis_map_example/nav/controls/dashboard/dashboard_control.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../data/nav_state.dart';
import '../data/object_info_state.dart';

///
class RoutingViewModel {
  ///
  RoutingViewModel(
    this.mapController, {
    this.freeRoamDefault = false,
  });

  ///
  final DgisMapController mapController;
  final bool freeRoamDefault;

  ///
  // late final DashboardControlController dashboardControlController;
  late final ValueNotifier<bool> isFreeRoam = ValueNotifier(freeRoamDefault);

  late final navRoutingType =
      ValueNotifier<RouteSearchOptionsMessage>(RouteSearchOptionsMessage.car);
  final navRoutingStartObjectId = ValueNotifier<ObjectInfoState?>(null);
  final navRoutingFinishObjectId = ValueNotifier<ObjectInfoState?>(null);

  late final navLastRouteSpec = ValueNotifier<RouteChangedEvent?>(null);
  late final navigationState = ValueNotifier(NavigationState.idle());

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

  NavigationEvent? _state;
  bool _routeHasOptions = false;

  final _subscriptions = <StreamSubscription>[];

  void init() {
    _subscriptions.add(
      mapController.routeOptionEvents.listen((event) {
        _routeHasOptions = event.hasOptions;
      }),
    );
    _subscriptions.add(
      routeChangedEvents.listen((event) => navLastRouteSpec.value = event),
    );
  }

  Future<bool> onWillPop() {
    print("onWillPop?");
    mapController.hideRoutes();
    return Future.value(true);
  }

  @override
  void dispose() {
    mapController.hideRoutes();
    for (final sub in _subscriptions) {
      unawaited(sub.cancel());
    }
    _subscriptions.clear();
  }

  void setFreeRoam() => isFreeRoam.value = (_state == NavigationEvent.disabled)
      ? freeRoamDefault
      : !_routeHasOptions;

  void onNavigationGoTap() {
    navigationState.value = NavigationState(
      isRunning: true,
      isFreeRoamMode: false,
    );

    unawaited(mapController.startNavigationSimulation());
    unawaited(WakelockPlus.enable());
  }

  void setRoutingType(RouteSearchOptionsMessage type) {
    navRoutingType.value = type;
    setRouteParams();
  }

  void setRouteParams() {
    GeoPointMessage? startPoint;
    if (navRoutingStartObjectId.value != null) {
      startPoint = GeoPointMessage(
        latitude: navRoutingStartObjectId.value!.latLng.latitude,
        longitude: navRoutingStartObjectId.value!.latLng.longitude,
      );
    }

    GeoPointMessage? finishPoint;
    if (navRoutingFinishObjectId.value != null) {
      finishPoint = GeoPointMessage(
        latitude: navRoutingFinishObjectId.value!.latLng.latitude,
        longitude: navRoutingFinishObjectId.value!.latLng.longitude,
      );
    }

    // можем передать какую-то конкретнуюю точку, а можем и нет, тогда в нативе возьмем текущую локацию
    final params = RouteEditorRouteParamsMessage(
      startPoint: startPoint,
      finishPoint: finishPoint,
      options: navRoutingType.value,
    );

    unawaited(mapController.setRouteParams(params));
  }

  void swapStartFinish() {
    final temp1 = navRoutingStartObjectId.value;
    final temp2 = navRoutingFinishObjectId.value;

    navRoutingStartObjectId.value = temp2;
    navRoutingFinishObjectId.value = temp1;
  }

  void onNavigationFinishClicked() {
    navigationState.value = NavigationState.idle();
    // generalControlsState.value = true;
    unawaited(mapController.stopNavigation());
    unawaited(WakelockPlus.disable());
    // onRoutingClose();
  }

  void onNavigationFreeRoamStop() {
    navigationState.value = NavigationState.idle();
    // generalControlsState.value = true;
    // unawaited(controller.freeRoamController.stop());
    unawaited(WakelockPlus.disable());
    // onRoutingClose();
  }
}
