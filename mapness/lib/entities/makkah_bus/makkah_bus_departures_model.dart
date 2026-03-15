import 'package:freezed_annotation/freezed_annotation.dart';

part 'makkah_bus_departures_model.freezed.dart';
part 'makkah_bus_departures_model.g.dart';

@freezed
abstract class MakkahBusDeparturesResponse with _$MakkahBusDeparturesResponse {
  const factory MakkahBusDeparturesResponse({
    required bool success,
    required MakkahBusDeparturesData data,
  }) = _MakkahBusDeparturesResponse;

  factory MakkahBusDeparturesResponse.fromJson(Map<String, dynamic> json) =>
      _$MakkahBusDeparturesResponseFromJson(json);
}

@freezed
abstract class MakkahBusDeparturesData with _$MakkahBusDeparturesData {
  const factory MakkahBusDeparturesData({
    @JsonKey(name: 'poi_id') required String poiId,
    @JsonKey(name: 'stop_id') required String stopId,
    required List<MakkahBusRoute> routes,
  }) = _MakkahBusDeparturesData;

  factory MakkahBusDeparturesData.fromJson(Map<String, dynamic> json) =>
      _$MakkahBusDeparturesDataFromJson(json);
}

@freezed
abstract class MakkahBusRoute with _$MakkahBusRoute {
  const factory MakkahBusRoute({
    @JsonKey(name: 'route_id') required String routeId,
    required String headsign,
    @JsonKey(name: 'route_short_name') required String routeShortName,
    @JsonKey(name: 'route_color') required String routeColor,
    @JsonKey(name: 'route_text_color') required String routeTextColor,
    @Default([]) List<MakkahBusTrip> trips,
  }) = _MakkahBusRoute;

  factory MakkahBusRoute.fromJson(Map<String, dynamic> json) =>
      _$MakkahBusRouteFromJson(json);
}

@freezed
abstract class MakkahBusTrip with _$MakkahBusTrip {
  const factory MakkahBusTrip({
    @JsonKey(name: 'trip_id') required String tripId,
    @JsonKey(name: 'departure_time') required String departureTime,
    @JsonKey(name: 'delay_seconds') required int delaySeconds,
    @JsonKey(name: 'sort_key') required String sortKey,
    @JsonKey(name: 'is_realtime') required bool isRealtime,
  }) = _MakkahBusTrip;

  factory MakkahBusTrip.fromJson(Map<String, dynamic> json) =>
      _$MakkahBusTripFromJson(json);
}
