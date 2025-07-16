import 'dart:ui';

import 'package:dgis_map/library.dart';
import 'package:mapness/widgets/path_nav/lib/utils.dart';

sealed class RouteDetailsPublicTransport {
  // in millimeters
  final int length;

  const RouteDetailsPublicTransport({
    required this.length,
  });
}

class RouteDetailsPublicTransportPedestrian extends RouteDetailsPublicTransport {
  final bool isTransfer;
  const RouteDetailsPublicTransportPedestrian({
    required super.length,
    this.isTransfer = false,
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

// If the next and previous routes have parts, then it is a public transport transfer
bool isTransfer(List<PublicTransportTransferRouteLongEntryMessage> pub, int index) {
  final next = pub.length > index + 1 ? pub[index + 1] : null;
  final prev = index - 1 >= 0 ? pub[index - 1] : null;
  if (next == null || prev == null) {
    return false;
  }
  return next.value.routeParts.isNotEmpty && prev.value.routeParts.isNotEmpty;
}
