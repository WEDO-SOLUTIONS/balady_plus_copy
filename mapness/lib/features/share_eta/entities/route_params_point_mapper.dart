import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';

extension RouteParamsPointWithLabelMapper on RouteParamsPointWithLabel {
  EtaRoutePoint get etaPoint => EtaRoutePoint(
        lat: value?.latitude,
        lon: value?.longitude,
        label: label,
      );
}

extension EtaRoutePointMapper on EtaRoutePoint {
  RouteParamsPoint? get routePoint => lat == null || lon == null
      ? null
      : RouteParamsPoint(
          latitude: lat!,
          longitude: lon!,
        );

  String get analyticsLabel => label ?? '$lat,$lon';
}
