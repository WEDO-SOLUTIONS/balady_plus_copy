import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_route.freezed.dart';
part 'current_route.g.dart';

final currentRouteProvider = _currentRouteProvider;

/// Who started the trip that is currently in guidance.
enum NavigationTripSource { phone, carplay, androidAuto }

/// This provider stores current route state
@Riverpod(keepAlive: true)
class _CurrentRoute extends _$CurrentRoute {
  @override
  CurrentRouteState? build() => null;

  void clearRoute() {
    state = null;
  }

  void addPointToRoute(RouteParamsPointWithLabel point) {
    final routeState = state;
    if (routeState == null) {
      return;
    }

    // do not add same object to route
    final pointObjectId = point.value?.objectId;
    if (pointObjectId != null && routeState.points.where((e) => e.value?.objectId == pointObjectId).isNotEmpty) {
      return;
    }

    final newPoints = routeState.points.isEmpty ? [point] : List.of(routeState.points)
      ..insert(routeState.points.length - 1, point);

    state = routeState.copyWith(points: newPoints);
  }

  void removePointFromRoute(int objectId) {
    final routeState = state;
    if (routeState == null) {
      return;
    }

    final newPoints = List.of(routeState.points)..removeWhere((element) => element.value?.objectId == objectId);
    // do not update route if nothing changed
    if (newPoints.length == routeState.points.length) {
      return;
    }

    state = routeState.copyWith(points: newPoints);
  }

  Future<void> setNavigationState(CurrentRouteState routeState) async {
    state = routeState;
  }

  /// Fills the route of a trip Flutter did not start (head unit, app restart); a known route wins.
  void seedFromNativeTrip(CurrentRouteState routeState) {
    state ??= routeState;
  }
}

@freezed
abstract class CurrentRouteState with _$CurrentRouteState {
  const factory CurrentRouteState({
    required List<RouteParamsPointWithLabel> points,
    required RouteSearchOptionsMessage navType,
    // Null for a trip picked up from native navigation: its planned route is unknown.
    required RouteInfo? route,
    int? activeIndex,
    @Default(NavigationTripSource.phone) NavigationTripSource tripSource,
  }) = _CurrentRouteState;

  const CurrentRouteState._();

  RouteParamsPointWithLabel? get startPoint => points.firstOrNull;

  RouteParamsPointWithLabel? get finishPoint => points.lastOrNull;

  RouteParamsPointList? get intermediatePointsWithLabels => points.getIntermediatePointsWithLabels();

  RouteParamsPointList? get intermediatePoints => points.map((e) => e.value).toList().getIntermediatePoints();

  bool containsIntermediatePOI(int objectId) =>
      intermediatePoints?.points.where((e) => e.value?.objectId == objectId).isNotEmpty ?? false;

  bool isStartOrFinishPOI(int objectId) =>
      [startPoint, finishPoint].nonNulls.where((e) => e.value?.objectId == objectId).isNotEmpty;
}
