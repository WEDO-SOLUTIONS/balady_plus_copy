import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

@freezed
abstract class BusDeparturesResponse with _$BusDeparturesResponse {
  const factory BusDeparturesResponse({
    required bool success,
    required BusDeparturesData data,
  }) = _BusDeparturesResponse;

  factory BusDeparturesResponse.fromJson(Map<String, dynamic> json) => _$BusDeparturesResponseFromJson(json);
}

@freezed
abstract class BusDeparturesData with _$BusDeparturesData {
  const factory BusDeparturesData({
    @JsonKey(name: 'poi_id') required String poiId,
    @JsonKey(name: 'transit_systems') @Default([]) List<TransitSystem> transitSystems,
  }) = _BusDeparturesData;

  factory BusDeparturesData.fromJson(Map<String, dynamic> json) => _$BusDeparturesDataFromJson(json);
}

@freezed
abstract class TransitSystem with _$TransitSystem {
  const factory TransitSystem({
    required String id,
    required String label,
    @Default([]) List<BusRoute> routes,
  }) = _TransitSystem;

  factory TransitSystem.fromJson(Map<String, dynamic> json) => _$TransitSystemFromJson(json);
}

@freezed
abstract class BusRoute with _$BusRoute {
  const factory BusRoute({
    @JsonKey(name: 'route_id') required String routeId,
    @JsonKey(name: 'stop_id') required String stopId,
    required String headsign,
    @JsonKey(name: 'route_short_name') required String routeShortName,
    @JsonKey(name: 'route_color') required String routeColor,
    @JsonKey(name: 'route_text_color') required String routeTextColor,
    @Default([]) List<BusTrip> trips,
  }) = _BusRoute;

  factory BusRoute.fromJson(Map<String, dynamic> json) => _$BusRouteFromJson(json);
}

@freezed
abstract class BusTrip with _$BusTrip {
  const factory BusTrip({
    @JsonKey(name: 'trip_id') required String tripId,
    @JsonKey(name: 'departure_time') required String departureTime,
    @JsonKey(name: 'delay_seconds') required int delaySeconds,
    @JsonKey(name: 'sort_key') required String sortKey,
    @JsonKey(name: 'is_realtime') required bool isRealtime,
    @JsonKey(name: 'departure_time_update') String? departureTimeUpdate,
  }) = _BusTrip;

  factory BusTrip.fromJson(Map<String, dynamic> json) => _$BusTripFromJson(json);
}
