import 'package:dgis_map/library.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes.g.dart';

@riverpod
class Routes extends _$Routes {
  @override
  List<RouteInfo> build({
    required RouteParamsPoint? startPoint,
    required RouteParamsPoint? finishPoint,
    required RouteSearchOptionsMessage navType,
  }) {
    final dgisController = ref.watch(dgisControllerProvider);
    final params = RouteEditorRouteParamsMessage(
      startPoint: startPoint?.geoPoint,
      finishPoint: finishPoint?.geoPoint,
      options: navType,
    );

    final routesInfoChangedSubscription =
        dgisController?.routesInfoChangedEvents.listen((event) {
      state = event.routes;
    });
    ref.onDispose(() {
      routesInfoChangedSubscription?.cancel();
    });

    print("rebuild routes?");

    dgisController?.setRouteParams(params);
    return [];
  }
}

@riverpod
class ActiveRoute extends _$ActiveRoute {
  @override
  int build() {
    final dgisController = ref.watch(dgisControllerProvider);

    final activeRouteSubscription =
        dgisController?.activeRouteChangedEvents.listen((event) {
      state = event.index;
    });
    ref.onDispose(() {
      activeRouteSubscription?.cancel();
    });
    return 0;
  }
}
