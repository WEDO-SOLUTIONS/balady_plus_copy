import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'eta_route_info_provider.g.dart';

@Riverpod(keepAlive: true)
class EtaRouteInfo extends _$EtaRouteInfo {
  @override
  EtaRoute build() => const EtaRoute();

  void setStartPoint(EtaRoutePoint point) {
    state = state.copyWith(startPoint: point);
  }

  void setEndPoint(EtaRoutePoint point) {
    state = state.copyWith(endPoint: point);
  }

  void setPoints(List<EtaRoutePoint> points) {
    if (points.isEmpty) {
      return;
    }
    if (points.length == 1) {
      setStartPoint(points.first);
      return;
    }
    if (points.length == 2) {
      state = state.copyWith(startPoint: points.first, endPoint: points.last);
      return;
    }
  }

  void setActiveRoute(int index) {
    state = state.copyWith(routeIndex: index);
  }

  void setRouteType(RouteType type) {
    state = state.copyWith(type: type);
  }

  // ignore: use_setters_to_change_properties
  void setRoute(EtaRoute route) {
    state = route;
  }

  void setCratedAt(DateTime time) {
    state = state.copyWith(createdAt: time.toIso8601String());
  }

  void clear() {
    state = const EtaRoute();
  }
}
