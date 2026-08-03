import 'dart:async';

import 'package:async/async.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/entities/path_nav/models/path_nav_better_route.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/navigator_route_settings.dart';
import 'package:mapness/shared/providers/map/road_event_excluded_areas.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes.g.dart';

class NoInternetException implements Exception {
  const NoInternetException();
}

class WalkingDistanceException implements Exception {
  const WalkingDistanceException();
}

@riverpod
class Routes extends _$Routes {
  @override
  Future<List<RouteInfo>> build({
    required RouteParamsPoint? startPoint,
    required RouteParamsPoint? finishPoint,
    required RouteSearchOptionsMessage navType,
    bool? showOnlyActiveRoute,
    RouteParamsPointList? intermediatePoints,
  }) async {
    final online = ref.watch(networkStatusProvider);
    await AdvancedMetrics.instance.startRouteCalculation(
      startPoint != null ? [startPoint.latitude, startPoint.longitude] : null,
      finishPoint != null ? [finishPoint.latitude, finishPoint.longitude] : null,
    );

    final dgisController = ref.watch(dgisControllerProvider);
    final searchOptions = ref.watch(navigatorRouteSettingsProvider);
    final excludedAreas = ref.watch(roadEventExcludedAreasProvider);

    final intermediatePoints = this.intermediatePoints?.points.map((e) => e.value?.pointMessage).nonNulls.toList();

    unawaited(dgisController.value?.hideRoutes());
    final params = RouteEditorRouteParamsMessage(
      startPoint: startPoint?.pointMessage,
      finishPoint: finishPoint?.pointMessage,
      options: navType,
      showOnlyActiveRoute: showOnlyActiveRoute,
      intermediatePoints: intermediatePoints,
      searchParams: CarRouteSearchOptionParamsMessage(
        avoidTollRoads: searchOptions.avoidTollRoads,
        avoidUnpavedRoads: searchOptions.avoidUnpavedRoads,
        excludedAreas: excludedAreas,
      ),
    );

    final cancelableCompleter = CancelableCompleter<List<RouteInfo>>();
    final subscription = dgisController.value?.routesInfoChangedEvents.listen((event) async {
      await dgisController.value?.showRoutes();
      await AdvancedMetrics.instance.stopRouteCalculation(track: ref.read(urbiAnalyticsProvider).track);
      if (!cancelableCompleter.isCompleted) {
        cancelableCompleter.complete(event.routes);
      }
    });

    ref.onDispose(() {
      subscription?.cancel();
      cancelableCompleter.operation.cancel();
    });

    if (!online && !cancelableCompleter.isCompleted) {
      cancelableCompleter.completeError(const NoInternetException());
    }

    await dgisController.value?.setRouteParams(params);
    try {
      return await cancelableCompleter.operation.value.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          if (!online) {
            throw const NoInternetException();
          }

          if (navType == RouteSearchOptionsMessage.pedestrian) {
            throw const WalkingDistanceException();
          }

          throw TimeoutException('Timeout while waiting for routes');
        },
      );
    } catch (e) {
      // Re-check network status
      if (!online) {
        throw const NoInternetException();
      }

      // Handle specific exception types
      if (e is NoInternetException) {
        rethrow;
      }

      if (e is WalkingDistanceException) {
        rethrow;
      }

      if (navType == RouteSearchOptionsMessage.pedestrian) {
        throw const WalkingDistanceException();
      }

      // Re-throw timeout or other exceptions
      rethrow;
    }
  }
}

@riverpod
class PublicTransportRoutes extends _$PublicTransportRoutes {
  @override
  Future<List<BriefPublicTransportModel>> build({
    required RouteParamsPoint? startPoint,
    required RouteParamsPoint? finishPoint,
    required RouteSearchOptionsMessage navType,
    bool? showOnlyActiveRoute,
    Duration? timeout,
    RouteParamsPointList? intermediatePoints,
  }) async {
    final online = ref.watch(networkStatusProvider);
    await AdvancedMetrics.instance.startRouteCalculation(
      startPoint != null ? [startPoint.latitude, startPoint.longitude] : null,
      finishPoint != null ? [finishPoint.latitude, finishPoint.longitude] : null,
    );

    final dgisController = ref.watch(dgisControllerProvider);
    final searchOptions = ref.watch(navigatorRouteSettingsProvider);
    final excludedAreas = ref.watch(roadEventExcludedAreasProvider);

    final intermediatePoints = this.intermediatePoints?.points.map((e) => e.value?.pointMessage).nonNulls.toList();

    final params = RouteEditorRouteParamsMessage(
      startPoint: startPoint?.pointMessage,
      finishPoint: finishPoint?.pointMessage,
      options: navType,
      showOnlyActiveRoute: showOnlyActiveRoute,
      intermediatePoints: intermediatePoints,
      searchParams: CarRouteSearchOptionParamsMessage(
        avoidTollRoads: searchOptions.avoidTollRoads,
        avoidUnpavedRoads: searchOptions.avoidUnpavedRoads,
        excludedAreas: excludedAreas,
      ),
    );

    final cancelableCompleter = CancelableCompleter<List<BriefPublicTransportModel>>();
    final publicTransportRoutesSubscription = dgisController.value?.publicTransportRoutesChangedEvents.listen((event) {
      if (!cancelableCompleter.isCompleted && navType == RouteSearchOptionsMessage.publicTransport) {
        cancelableCompleter.complete(event.routes);
      }
    });

    ref.onDispose(() {
      publicTransportRoutesSubscription?.cancel();
      cancelableCompleter.operation.cancel();
    });

    if (!online && !cancelableCompleter.isCompleted) {
      cancelableCompleter.completeError(const NoInternetException());
    }

    await dgisController.value?.setRouteParams(params);
    try {
      return await cancelableCompleter.operation.value.timeout(
        timeout ?? const Duration(seconds: 10),
        onTimeout: () {
          if (!online) {
            throw const NoInternetException();
          }

          throw TimeoutException('Timeout while waiting for public transport routes');
        },
      );
    } catch (e) {
      // Re-check network status
      if (!online) {
        throw const NoInternetException();
      }

      // Handle specific exception types
      if (e is NoInternetException) {
        rethrow;
      }

      // Re-throw timeout or other exceptions
      rethrow;
    }
  }
}

@riverpod
class ActiveRoute extends _$ActiveRoute {
  @override
  int build() {
    final dgisController = ref.watch(dgisControllerProvider);

    final activeRouteSubscription = dgisController.value?.activeRouteChangedEvents.listen((event) {
      state = event.index;
    });
    ref.onDispose(() {
      activeRouteSubscription?.cancel();
    });
    return 0;
  }
}

@riverpod
class BetterRoute extends _$BetterRoute {
  StreamSubscription<BetterRouteInfoEvent>? betterRouteSubscription;

  @override
  PathNavBetterRoute? build() {
    final dgisController = ref.watch(dgisControllerProvider);

    final suggestBetterRoute = ref.watch(betterRouteSuggestionsProvider);

    dgisController.value?.setBetterRouteEnabled(enabled: suggestBetterRoute);

    if (suggestBetterRoute) {
      betterRouteSubscription ??= dgisController.value?.betterRouteInfoEvents.listen((event) {
        state = event.route != null
            ? PathNavBetterRoute(route: event.route!, durationProfit: event.durationProfit)
            : null;
      });
      state = null;
    } else {
      betterRouteSubscription?.cancel();
      betterRouteSubscription = null;
      state = null;
    }

    ref.onDispose(() {
      betterRouteSubscription?.cancel();
    });
    return state;
  }
}

const String _suggestRouteBetterKey = 'navigator_settings.suggest_route_better';

@riverpod
class BetterRouteSuggestions extends _$BetterRouteSuggestions {
  @override
  bool build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);

    final suggestRouteBetter = sharedPrefs.getBool(_suggestRouteBetterKey) ?? true;

    return suggestRouteBetter;
  }

  void toggle() {
    state = !state;
    ref.read(sharedPrefsProvider).setBool(_suggestRouteBetterKey, state);
  }
}

@riverpod
class BetterRouteSettings extends _$BetterRouteSettings {
  static final prod = BetterRouteSettingsMessage(
    routeSearchDelay: 20,
    betterRouteTimeCostThreshold: 2 * 60,
    betterRouteLengthThreshold: 500 * 1000,
  );

  static final test = BetterRouteSettingsMessage(
    routeSearchDelay: 5,
    betterRouteTimeCostThreshold: 5,
    betterRouteLengthThreshold: 1000,
  );

  @override
  Future<BetterRouteSettingsMessage?> build() async {
    final dgisController = ref.read(dgisControllerProvider);
    return dgisController.value?.getBetterRouteSettings();
  }

  Future<void> setSettings(BetterRouteSettingsMessage settings) async {
    final dgisController = ref.read(dgisControllerProvider);
    final betterRoute = ref.read(betterRouteSuggestionsProvider);
    await dgisController.value?.setBetterRouteEnabled(enabled: betterRoute);
    await dgisController.value?.setBetterRouteSettings(settings);
    final updatedSettings = await dgisController.value?.getBetterRouteSettings();
    state = AsyncData(updatedSettings);
  }
}

final currentNavigationDestinationProvider = StateProvider<RouteParamsPoint?>((ref) => null);
