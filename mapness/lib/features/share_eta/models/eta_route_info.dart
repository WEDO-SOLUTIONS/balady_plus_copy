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

/// Represents the ETA payload.
@freezed
class EtaRoutePayload with _$EtaRoutePayload {
  /// Default constructor for [EtaRoutePayload].
  @JsonSerializable(explicitToJson: true)
  const factory EtaRoutePayload({
    final Route? route,
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
    final Route? route,
  }) = _EtaRouteMetadataPayload;

  /// Creates an [EtaRoutePayload] object from a JSON map.
  factory EtaRouteMetadataPayload.fromJson(Map<String, dynamic> json) => _$EtaRouteMetadataPayloadFromJson(json);
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
class Route with _$Route {
  /// Default constructor for [Route].
  @JsonSerializable(explicitToJson: true)
  const factory Route({
    final String? algorithm,
    @JsonKey(name: 'begin_pedestrian_path') final PedestrianPath? beginPedestrianPath,
    @JsonKey(name: 'end_pedestrian_path') final PedestrianPath? endPedestrianPath,
    @JsonKey(name: 'filter_road_types') final List<String>? filterRoadTypes,
    final String? id,
    final List<Maneuver>? maneuvers,
    final double? reliability,
    @JsonKey(name: 'route_id') final String? routeId,
    @JsonKey(name: 'total_distance') final int? totalDistance,
    @JsonKey(name: 'total_duration') final int? totalDuration,
    final String? type,
    @JsonKey(name: 'ui_total_distance') final UiTotalDistance? uiTotalDistance,
    @JsonKey(name: 'ui_total_duration') final String? uiTotalDuration,
    final List<Waypoint>? waypoints,
  }) = _Route;

  /// Creates a [Route] object from a JSON map.
  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);
}

/// Represents a pedestrian path.
@freezed
class PedestrianPath with _$PedestrianPath {
  /// Default constructor for [PedestrianPath].
  @JsonSerializable(explicitToJson: true)
  const factory PedestrianPath({
    final Geometry? geometry,
  }) = _PedestrianPath;

  /// Creates a [PedestrianPath] object from a JSON map.
  factory PedestrianPath.fromJson(Map<String, dynamic> json) => _$PedestrianPathFromJson(json);
}

/// Represents a geometry.
@freezed
class Geometry with _$Geometry {
  /// Default constructor for [Geometry].
  const factory Geometry({
    final String? selection,
  }) = _Geometry;

  /// Creates a [Geometry] object from a JSON map.
  factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);
}

/// Represents a maneuver.
@freezed
class Maneuver with _$Maneuver {
  /// Default constructor for [Maneuver].
  @JsonSerializable(explicitToJson: true)
  const factory Maneuver({
    final String? comment,
    final String? icon,
    final String? id,
    @JsonKey(name: 'outcoming_path') final OutcomingPath? outcomingPath,
    @JsonKey(name: 'outcoming_path_comment') final String? outcomingPathComment,
    final ManeuverType? type,
  }) = _Maneuver;

  /// Creates a [Maneuver] object from a JSON map.
  factory Maneuver.fromJson(Map<String, dynamic> json) => _$ManeuverFromJson(json);
}

/// Enum representing the maneuver type.
enum ManeuverType {
  @JsonValue('begin')
  begin,
  @JsonValue('end')
  end,
}

/// Represents an outcoming path.
@freezed
class OutcomingPath with _$OutcomingPath {
  /// Default constructor for [OutcomingPath].
  const factory OutcomingPath({
    final int? distance,
    final int? duration,
    final List<OutcomingPathGeometry>? geometry,
    final List<String>? names,
  }) = _OutcomingPath;

  /// Creates an [OutcomingPath] object from a JSON map.
  factory OutcomingPath.fromJson(Map<String, dynamic> json) => _$OutcomingPathFromJson(json);
}

/// Represents a geometry of an outcoming path.
@freezed
class OutcomingPathGeometry with _$OutcomingPathGeometry {
  /// Default constructor for [OutcomingPathGeometry].
  const factory OutcomingPathGeometry({
    final String? color,
    final int? length,
    final String? style,
  }) = _OutcomingPathGeometry;

  /// Creates an [OutcomingPathGeometry] object from a JSON map.
  factory OutcomingPathGeometry.fromJson(Map<String, dynamic> json) => _$OutcomingPathGeometryFromJson(json);
}

/// Represents the UI total distance.
@freezed
class UiTotalDistance with _$UiTotalDistance {
  /// Default constructor for [UiTotalDistance].
  const factory UiTotalDistance({
    final String? unit,
    final String? value,
  }) = _UiTotalDistance;

  /// Creates a [UiTotalDistance] object from a JSON map.
  factory UiTotalDistance.fromJson(Map<String, dynamic> json) => _$UiTotalDistanceFromJson(json);
}

/// Represents a waypoint.
@freezed
class Waypoint with _$Waypoint {
  /// Default constructor for [Waypoint].
  const factory Waypoint({
    @JsonKey(name: 'original_point') final OriginalPoint? originalPoint,
    @JsonKey(name: 'projected_point') final ProjectedPoint? projectedPoint,
    final bool? transit,
  }) = _Waypoint;

  /// Creates a [Waypoint] object from a JSON map.
  factory Waypoint.fromJson(Map<String, dynamic> json) => _$WaypointFromJson(json);
}

/// Represents an original point.
@freezed
class OriginalPoint with _$OriginalPoint {
  /// Default constructor for [OriginalPoint].
  const factory OriginalPoint({
    final double? lat,
    final double? lon,
  }) = _OriginalPoint;

  /// Creates an [OriginalPoint] object from a JSON map.
  factory OriginalPoint.fromJson(Map<String, dynamic> json) => _$OriginalPointFromJson(json);
}

/// Represents a projected point.
@freezed
class ProjectedPoint with _$ProjectedPoint {
  /// Default constructor for [ProjectedPoint].
  const factory ProjectedPoint({
    final double? lat,
    final double? lon,
  }) = _ProjectedPoint;

  /// Creates a [ProjectedPoint] object from a JSON map.
  factory ProjectedPoint.fromJson(Map<String, dynamic> json) => _$ProjectedPointFromJson(json);
}
