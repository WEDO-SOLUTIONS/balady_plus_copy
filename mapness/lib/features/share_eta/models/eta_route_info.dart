/// This file contains the model classes for ETA route information.

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'eta_route_info.freezed.dart';
part 'eta_route_info.g.dart';

enum StreamType {
  @JsonValue('eta')
  eta,
  @JsonValue('geo')
  geo,
}

enum RouteType {
  @JsonValue('car')
  car,
  @JsonValue('pedestrian')
  pedestrian,
  @JsonValue('public_transport')
  publicTransport,
}

/// Represents the ETA payload.
@freezed
class EtaRoutePayload with _$EtaRoutePayload {
  /// Default constructor for [EtaRoutePayload].
  @JsonSerializable(explicitToJson: true)
  const factory EtaRoutePayload({
    final EtaRoute? route,
    final User? user,
    final StreamType? type,
  }) = _EtaRoutePayload;

  /// Creates an [EtaRoutePayload] object from a JSON map.
  factory EtaRoutePayload.fromJson(Map<String, dynamic> json) => _$EtaRoutePayloadFromJson(json);
}

/// Represents the ETA route update metadata.
@freezed
class EtaRouteMetadataPayload with _$EtaRouteMetadataPayload {
  /// Default constructor for [EtaRoutePayload].
  @JsonSerializable(explicitToJson: true)
  const factory EtaRouteMetadataPayload({
    required final EtaRoute route,
  }) = _EtaRouteMetadataPayload;

  /// Creates an [EtaRoutePayload] object from a JSON map.
  factory EtaRouteMetadataPayload.fromJson(Map<String, dynamic> json) => _$EtaRouteMetadataPayloadFromJson(json);
}

@freezed
class EtaRouteUpdatePayload with _$EtaRouteUpdatePayload {
  @JsonSerializable(explicitToJson: true)
  const factory EtaRouteUpdatePayload({
    required final EtaRouteMetadataPayload metadata,
  }) = _EtaRouteUpdatePayload;

  factory EtaRouteUpdatePayload.fromJson(Map<String, dynamic> json) => _$EtaRouteUpdatePayloadFromJson(json);
}

/// Represents a user.
@freezed
class User with _$User {
  /// Default constructor for [User].
  const factory User({
    @JsonKey(name: 'first_name') final String? firstName,
    @JsonKey(name: 'last_name') final String? lastName,
    @JsonKey(name: 'photo_url') final String? photoUrl,
  }) = _User;

  /// Creates a [User] object from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// Represents a route.
@freezed
class EtaRoute with _$EtaRoute {
  /// Default constructor for [EtaRoute].
  @JsonSerializable(explicitToJson: true)
  const factory EtaRoute({
    @JsonKey(name: 'start_point') final EtaRoutePoint? startPoint,
    @JsonKey(name: 'end_point') final EtaRoutePoint? endPoint,
    final RouteType? type,
    @JsonKey(name: 'route_index') final int? routeIndex,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _EtaRoute;

  /// Creates a [EtaRoute] object from a JSON map.
  factory EtaRoute.fromJson(Map<String, dynamic> json) => _$EtaRouteFromJson(json);
}

// Check if the route is not set
extension RouteX on EtaRoute {
  bool get isEmpty => startPoint == null || endPoint == null || type == null || routeIndex == null;
}

/// Represents the ETA route point information.
@freezed
class EtaRoutePoint with _$EtaRoutePoint {
  /// Default constructor for [EtaRoutePoint].
  @JsonSerializable(explicitToJson: true)
  const factory EtaRoutePoint({
    final double? lat,
    final double? lon,
    final String? label,
  }) = _EtaRoutePoint;

  /// Creates an [EtaRoutePoint] object from a JSON map.
  factory EtaRoutePoint.fromJson(Map<String, dynamic> json) => _$EtaRoutePointFromJson(json);
}
