import 'package:dgis_map_platform_interface/library.dart';

extension PublicTransportTransferRouteLongEntryMessageExt on PublicTransportTransferRouteLongEntryMessage {
  static PublicTransportTransferRouteLongEntryMessage fromJson(Map<String, dynamic> transfer) {
    final point = transfer['point'] as Map?;
    if (point == null) {
      throw ArgumentError('point field is required but was null');
    }

    final pointMap = Map<String, dynamic>.from(point);
    final distance = pointMap['distance'] as Map?;
    if (distance == null) {
      throw ArgumentError('distance field is required but was null');
    }

    final distanceMap = Map<String, dynamic>.from(distance);
    final distanceMm = distanceMap['millimeters'] as int? ?? 0;

    final length = transfer['length'] as Map?;
    if (length == null) {
      throw ArgumentError('length field is required but was null');
    }

    final lengthMap = Map<String, dynamic>.from(length);
    final lengthMm = lengthMap['millimeters'] as int? ?? 0;

    final value = Map<String, dynamic>.from(transfer['value'] as Map);

    return PublicTransportTransferRouteLongEntryMessage(
      point: RoutePointMessage(
        distance: RouteDistanceMessage(
          millimeters: distanceMm,
        ),
      ),
      length: RouteDistanceMessage(
        millimeters: lengthMm,
      ),
      value: PublicTransportTransferMessageExt.fromJson(value),
    );
  }

  /// In minutes
  int? distanceToPedestrianTime(int? distanceMillimeters) {
    if (distanceMillimeters == null) {
      return null;
    }
    final meters = distanceMillimeters / 1000;
    const pedestrianSpeed = 100; // meter per minute
    final time = meters / pedestrianSpeed;
    return time.round();
  }
}

extension PublicTransportInfoMessageExt on PublicTransportInfoMessage {
  static PublicTransportInfoMessage fromJson(Map<String, dynamic> transport) {
    final type = _parseRouteType(transport['type']);
    return PublicTransportInfoMessage(
      type: type,
      names: (transport['names'] as List<dynamic>?)?.cast<String>() ?? [],
      suggestedCarNumbers: (transport['suggestedCarNumbers'] as List<dynamic>?)?.cast<int>() ?? [],
      boardingSuggest: transport['boardingSuggest'] as String? ?? '',
      color: transport['color'] as int?,
      routeLogo: transport['routeLogo'] as String? ?? '',
    );
  }
}

extension PublicTransportStopMessageExt on PublicTransportStopMessage {
  static PublicTransportStopMessage fromJson(Map<String, dynamic> stop) {
    final coordinates = stop['coordinates'] as Map?;
    return PublicTransportStopMessage(
      coordinates: GeoPointMessage(
        latitude: coordinates != null ? (Map<String, dynamic>.from(coordinates)['latitude'] as double? ?? 0.0) : 0.0,
        longitude: coordinates != null ? (Map<String, dynamic>.from(coordinates)['longitude'] as double? ?? 0.0) : 0.0,
      ),
      name: stop['name'] as String? ?? '',
    );
  }
}

extension PublicTransportTransferMessageExt on PublicTransportTransferMessage {
  static PublicTransportTransferMessage fromJson(Map<String, dynamic> routes) => PublicTransportTransferMessage(
        startPointName: routes['startPointName'] as String? ?? '',
        finishPointName: routes['finishPointName'] as String? ?? '',
        routeParts: (routes['routeParts'] as List<dynamic>?)
                ?.map((routePart) => PublicRoutePartMessageExt.fromJson(Map<String, dynamic>.from(routePart as Map)))
                .toList() ??
            [],
      );
}

extension PublicRoutePartMessageExt on PublicRoutePartMessage {
  static PublicRoutePartMessage fromJson(Map<String, dynamic> routePart) {
    final transports = (routePart['transports'] as List<dynamic>?)?.cast<Map>() ?? [];
    final intermediateStops = (routePart['intermediateStops'] as List<dynamic>?)?.cast<Map>() ?? [];
    return PublicRoutePartMessage(
      transports: transports
          .map((transport) => PublicTransportInfoMessageExt.fromJson(Map<String, dynamic>.from(transport)))
          .toList(),
      intermediateStops: intermediateStops
          .map((stop) => PublicTransportStopMessageExt.fromJson(Map<String, dynamic>.from(stop)))
          .toList(),
    );
  }
}

PublicTransportRouteTypeMessage _parseRouteType(type) {
  if (type is String) {
    return PublicTransportRouteTypeMessage.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == type.toLowerCase(),
      orElse: () => PublicTransportRouteTypeMessage.bus,
    );
  }
  return PublicTransportRouteTypeMessage.bus;
}
