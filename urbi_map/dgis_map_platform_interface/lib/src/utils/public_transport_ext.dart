import 'package:dgis_map_platform_interface/library.dart';

extension PublicTransportInfoMessageExt on PublicTransportInfoMessage {
  static PublicTransportInfoMessage fromJson(Map<String, dynamic> transport) => PublicTransportInfoMessage(
        type: _parseRouteType(transport['type']),
        names: (transport['names'] as List<dynamic>?)?.cast<String>() ?? [],
        suggestedCarNumbers: (transport['suggestedCarNumbers'] as List<dynamic>?)?.cast<int>() ?? [],
        boardingSuggest: transport['boardingSuggest'] as String? ?? '',
        color: transport['color'] as int?,
        routeLogo: transport['routeLogo'] as String? ?? '',
      );
}

extension PublicTransportStopMessageExt on PublicTransportStopMessage {
  static PublicTransportStopMessage fromJson(Map<String, dynamic> stop) => PublicTransportStopMessage(
        coordinates: GeoPointMessage(
          latitude: (stop['coordinates'] as Map<String, dynamic>?)?['latitude'] as double? ?? 0.0,
          longitude: (stop['coordinates'] as Map<String, dynamic>?)?['longitude'] as double? ?? 0.0,
        ),
        name: stop['name'] as String? ?? '',
      );
}

extension PublicTransportTransferMessageExt on PublicTransportTransferMessage {
  PublicTransportTransferMessage fromBrief(Map<String, dynamic> routes) => PublicTransportTransferMessage(
        startPointName: routes['startPointName'] as String? ?? '',
        finishPointName: routes['finishPointName'] as String? ?? '',
        routeParts: (routes['routeParts'] as List<dynamic>?)
                ?.map((routePart) => PublicRoutePartMessageExt.fromJson(routePart as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

extension PublicRoutePartMessageExt on PublicRoutePartMessage {
  static PublicRoutePartMessage fromJson(Map<String, dynamic> routePart) {
    final transports = (routePart['transports'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    final intermediateStops = (routePart['intermediateStops'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    return PublicRoutePartMessage(
      transports: transports.map((transport) => PublicTransportInfoMessageExt.fromJson(transport)).toList(),
      intermediateStops: intermediateStops.map((stop) => PublicTransportStopMessageExt.fromJson(stop)).toList(),
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
