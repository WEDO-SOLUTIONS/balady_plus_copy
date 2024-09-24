import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/entities/path_nav/models/path_nav_better_route.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
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
    final dgisController = ref.watch(dgisControllerProvider);
    unawaited(dgisController.value?.hideRoutes());
    final params = RouteEditorRouteParamsMessage(
      startPoint: startPoint?.pointMessage,
      finishPoint: finishPoint?.pointMessage,
      options: navType,
      showOnlyActiveRoute: showOnlyActiveRoute,
    );

    final routesCompleter = Completer<List<RouteInfo>>();
    final subscribtion = dgisController.value?.routesInfoChangedEvents.listen((event) async {
      await dgisController.value?.showRoutes();
      routesCompleter.complete(event.routes);
    });
    Timer(const Duration(minutes: 2), () {
      if (routesCompleter.isCompleted) {
        return;
      }
      routesCompleter.completeError(TimeoutException('no routes fond in time'));
    });

    ref.onDispose(() {
      subscribtion?.cancel();
      ref.read(cameraPaddingProvider.notifier).resetPadding();
    });

    await dgisController.value?.setRouteParams(params);
    return routesCompleter.future;
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
  @override
  PathNavBetterRoute? build() {
    final dgisController = ref.watch(dgisControllerProvider);

    final betterRouteSubscription = dgisController.value?.betterRouteInfoEvents.listen((event) {
      state = event.route != null
          ? PathNavBetterRoute(
              route: event.route!,
              durationProfit: event.durationProfit,
            )
          : null;
    });

    ref.onDispose(() {
      betterRouteSubscription?.cancel();
    });
    return null;
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
    await dgisController.value?.setBetterRouteSettings(settings);
    state = AsyncData(settings);
  }
}
