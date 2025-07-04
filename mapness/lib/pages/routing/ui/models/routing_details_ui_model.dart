import 'dart:ui';

import 'package:mapness/widgets/path_nav/lib/utils.dart';

sealed class RouteDetailsPublicTransport {
  // in millimeters
  final int length;

  const RouteDetailsPublicTransport({
    required this.length,
  });
}

class RouteDetailsPublicTransportPedestrian extends RouteDetailsPublicTransport {
  const RouteDetailsPublicTransportPedestrian({
    required super.length,
  });

  int get lengthInMeters => (length / 1000).round();
  double get lengthInKm => lengthInMeters / 1000;
  int get duration => durationByFoot(length);
}

class RouteDetailsPublicTransportMetro extends RouteDetailsPublicTransport {
  final List<RoutePart> routeParts;
  final Color? lineColor;

  const RouteDetailsPublicTransportMetro({
    required super.length,
    required this.routeParts,
    this.lineColor,
  });
}

/// Metro route part
///
/// Example:
/// [
///   // Line 1
///   RoutePart(stations: ['Station 1', 'Station 2', 'Station 3']),
///   // Line 2
///   RoutePart(stations: ['Station 4', 'Station 5', 'Station 6']),
/// ]
class RoutePart {
  final List<String> stations;

  const RoutePart({
    required this.stations,
  });
}
