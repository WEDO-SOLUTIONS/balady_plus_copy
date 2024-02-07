import 'package:dgis_map/library.dart';

extension RouteSearchOptionsMessageIcon on RouteSearchOptionsMessage {
  String get icon => switch (this) {
        RouteSearchOptionsMessage.pedestrian =>
          'assets/icons/svg/ic_routing_pedestrian.svg',
        RouteSearchOptionsMessage.car => 'assets/icons/svg/ic_routing_car.svg',
        _ => throw UnimplementedError('Not supported routing type'),
      };
}
