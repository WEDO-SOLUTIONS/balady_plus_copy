import 'dart:ui';

import 'package:dgis_map/library.dart';

enum RoutePointType { object, myLocation }

class RoutePoint {
  final RoutePointType type;
  final DirectoryObjectMessage? object;

  RoutePoint({
    required this.type,
    required this.object,
  });
}

extension RoutePointData on RoutePoint {
  String get icon => switch (type) {
        RoutePointType.myLocation => "assets/icons/svg/ic_routing_location.svg",
        RoutePointType.object => "assets/icons/svg/ic_routing_circle.svg",
      };

  String? get title => switch (type) {
        RoutePointType.myLocation => "My Location",
        RoutePointType.object => object?.title
      };

  Color get titleColor => switch (type) {
        RoutePointType.myLocation => const Color(0xFF1E2A36),
        RoutePointType.object =>
          object == null ? const Color(0x801E2A36) : const Color(0xFF1E2A36),
      };

  bool get isNotEmpty => switch (type) {
        RoutePointType.myLocation => true,
        RoutePointType.object => object != null,
      };

  double? get latitude => object?.markerPosition?.latitude;
  double? get longitude => object?.markerPosition?.longitude;
}
