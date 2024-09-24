import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';

extension RouteParamsPointMapper on RouteParamsPoint {
  EtaRoutePoint get etaPoint => EtaRoutePoint(
        lat: latitude,
        lon: longitude,
      );
}

extension EtaRoutePointMapper on EtaRoutePoint {
  RouteParamsPoint? get routePoint => lat == null || lon == null
      ? null
      : RouteParamsPoint(
          latitude: lat!,
          longitude: lon!,
        );
}
