import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
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
  }) {
    final dgisController = ref.watch(dgisControllerProvider);
    final params = RouteEditorRouteParamsMessage(
      startPoint: startPoint?.pointMessage,
      finishPoint: finishPoint?.pointMessage,
      options: navType,
    );

    final routesCompleter = Completer<List<RouteInfo>>();
    final routesInfoChangedSubscription =
        dgisController.value?.routesInfoChangedEvents.listen((event) {
      routesCompleter.complete(event.routes);
    });
    Timer(const Duration(minutes: 2), () {
      if (routesCompleter.isCompleted) {
        return;
      }
      routesCompleter.completeError(TimeoutException('no routes fond in time'));
    });
    ref.onDispose(() {
      routesInfoChangedSubscription?.cancel();
    });

    dgisController.value?.setRouteParams(params);
    return routesCompleter.future;
  }
}

@riverpod
class ActiveRoute extends _$ActiveRoute {
  @override
  int build() {
    final dgisController = ref.watch(dgisControllerProvider);

    final activeRouteSubscription =
        dgisController.value?.activeRouteChangedEvents.listen((event) {
      state = event.index;
    });
    ref.onDispose(() {
      activeRouteSubscription?.cancel();
    });
    return 0;
  }
}
