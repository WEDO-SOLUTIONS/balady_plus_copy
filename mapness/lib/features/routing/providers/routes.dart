import 'dart:async';

import 'package:async/async.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/entities/path_nav/models/path_nav_better_route.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/navigator_route_settings.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes.g.dart';

@riverpod
class Routes extends _$Routes {
  @override
  Future<List<RouteInfo>> build({
    required RouteParamsPoint? startPoint,
    required RouteParamsPoint? finishPoint,
    required RouteSearchOptionsMessage navType,
    bool? showOnlyActiveRoute,
  }) async {
    await AdvancedMetrics.instance.startRouteCalculation(
      startPoint != null ? [startPoint.latitude, startPoint.longitude] : null,
      finishPoint != null ? [finishPoint.latitude, finishPoint.longitude] : null,
    );

    final dgisController = ref.watch(dgisControllerProvider);
    final searchOptions = ref.watch(navigatorRouteSettingsProvider);

    unawaited(dgisController.value?.hideRoutes());
    final params = RouteEditorRouteParamsMessage(
      startPoint: startPoint?.pointMessage,
      finishPoint: finishPoint?.pointMessage,
      options: navType,
      showOnlyActiveRoute: showOnlyActiveRoute,
      searchParams: CarRouteSearchOptionParamsMessage(
        avoidTollRoads: searchOptions.avoidTollRoads,
        avoidUnpavedRoads: searchOptions.avoidUnpavedRoads,
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

    await dgisController.value?.setRouteParams(params);
    try {
      return await cancelableCompleter.operation.value.timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Timeout while waiting for routes'),
      );
    } catch (e) {
      throw TimeoutException('Timeout while waiting for routes');
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
            ? PathNavBetterRoute(
                route: event.route!,
                durationProfit: event.durationProfit,
              )
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
    state = AsyncData(settings);
  }
}
