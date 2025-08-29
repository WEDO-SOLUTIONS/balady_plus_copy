import 'package:dgis_map/library.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';

extension RouteTypeMapper on RouteSearchOptionsMessage {
  RouteType toRouteType() => switch (this) {
        RouteSearchOptionsMessage.car => RouteType.car,
        RouteSearchOptionsMessage.pedestrian => RouteType.pedestrian,
        RouteSearchOptionsMessage.publicTransport => RouteType.publicTransport,
        _ => throw Exception('Unknown RouteSearchOptionsMessage: $this'),
      };
}

extension RouteParamsPointMapper on RouteType {
  RouteSearchOptionsMessage get toRouteSearchOptions => switch (this) {
        RouteType.car => RouteSearchOptionsMessage.car,
        RouteType.pedestrian => RouteSearchOptionsMessage.pedestrian,
        RouteType.publicTransport => RouteSearchOptionsMessage.publicTransport,
      };
}
