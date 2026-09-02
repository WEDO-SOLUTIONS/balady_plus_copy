import 'dart:math' as math;

import 'package:mapness/features/road_events/domain/road_event.dart';

/// Hand-written, defensive parsing (rather than `json_serializable`) matching a
/// real Road Event Service response captured from `GET /config`. All fields are
/// captured even though only `feedbackCardDismissSeconds`/`corridorWidthMeters`
/// are currently consumed by `RoadEventConfig.toDomain()` — keeping the rest
/// documented in code for when more tunables get wired in.
class RoadEventConfigResponseDto {
  const RoadEventConfigResponseDto({
    this.version,
    this.ttlSeconds,
    this.reportRadiusMeters,
    this.feedbackRadiusMeters,
    this.feedbackCooldownMinutes,
    this.allowSelfFeedback,
    this.snapRadiusMeters,
    this.dedupCrossType,
    this.autoCardDistanceMeters,
    this.autoCardDismissSeconds,
    this.tappedCardDismissSeconds,
    this.feedbackCardDismissSeconds,
    this.maxMarkersPerViewport,
    this.pollIntervalSeconds,
    this.maxRoutePolylinePoints,
    this.corridorWidthMeters,
    this.eventTypes,
    this.serverTime,
    this.config,
    this.cacheTtlSec,
    this.generatedAt,
  });

  final String? version;
  final int? ttlSeconds;
  final double? reportRadiusMeters;
  final double? feedbackRadiusMeters;
  final int? feedbackCooldownMinutes;
  final bool? allowSelfFeedback;
  final double? snapRadiusMeters;
  final bool? dedupCrossType;
  final double? autoCardDistanceMeters;
  final int? autoCardDismissSeconds;
  final int? tappedCardDismissSeconds;
  final int? feedbackCardDismissSeconds;
  final int? maxMarkersPerViewport;
  final int? pollIntervalSeconds;
  final int? maxRoutePolylinePoints;
  final double? corridorWidthMeters;
  final List<RoadEventTypeConfigDto>? eventTypes;
  final String? serverTime;

  /// Admin-mirror block (`SCREAMING_SNAKE_CASE` keys) duplicating the top-level
  /// fields above — kept raw/untyped since it's not meant to be read by the
  /// client, only logged/inspected if ever needed.
  final Map<String, dynamic>? config;
  final int? cacheTtlSec;
  final String? generatedAt;

  factory RoadEventConfigResponseDto.fromJson(Map<String, dynamic> json) => RoadEventConfigResponseDto(
    version: json['version'] as String?,
    ttlSeconds: (json['ttlSeconds'] as num?)?.toInt(),
    reportRadiusMeters: (json['reportRadiusMeters'] as num?)?.toDouble(),
    feedbackRadiusMeters: (json['feedbackRadiusMeters'] as num?)?.toDouble(),
    feedbackCooldownMinutes: (json['feedbackCooldownMinutes'] as num?)?.toInt(),
    allowSelfFeedback: json['allowSelfFeedback'] as bool?,
    snapRadiusMeters: (json['snapRadiusMeters'] as num?)?.toDouble(),
    dedupCrossType: json['dedupCrossType'] as bool?,
    autoCardDistanceMeters: (json['autoCardDistanceMeters'] as num?)?.toDouble(),
    autoCardDismissSeconds: (json['autoCardDismissSeconds'] as num?)?.toInt(),
    tappedCardDismissSeconds: (json['tappedCardDismissSeconds'] as num?)?.toInt(),
    feedbackCardDismissSeconds: (json['feedbackCardDismissSeconds'] as num?)?.toInt(),
    maxMarkersPerViewport: (json['maxMarkersPerViewport'] as num?)?.toInt(),
    pollIntervalSeconds: (json['pollIntervalSeconds'] as num?)?.toInt(),
    maxRoutePolylinePoints: (json['maxRoutePolylinePoints'] as num?)?.toInt(),
    corridorWidthMeters: (json['corridorWidthMeters'] as num?)?.toDouble(),
    eventTypes: (json['eventTypes'] as List?)
        ?.whereType<Map<String, dynamic>>()
        .map(RoadEventTypeConfigDto.fromJson)
        .toList(),
    serverTime: json['serverTime'] as String?,
    config: (json['config'] as Map?)?.cast<String, dynamic>(),
    cacheTtlSec: (json['cacheTtlSec'] as num?)?.toInt(),
    generatedAt: json['generatedAt'] as String?,
  );

  RoadEventConfig toDomain() => RoadEventConfig(
    feedbackCardDismissSeconds: feedbackCardDismissSeconds ?? RoadEventConfig.defaultFeedbackCardDismissSeconds,
    corridorWidthMeters: corridorWidthMeters ?? RoadEventConfig.defaultCorridorWidthMeters,
    pollIntervalSeconds: math.max(
      RoadEventConfig.minPollIntervalSeconds,
      pollIntervalSeconds ?? RoadEventConfig.defaultPollIntervalSeconds,
    ),
  );
}

class RoadEventTypeConfigDto {
  const RoadEventTypeConfigDto({this.type, this.labelEn, this.labelAr, this.lanesEnabled});

  final String? type;
  final String? labelEn;
  final String? labelAr;
  final bool? lanesEnabled;

  factory RoadEventTypeConfigDto.fromJson(Map<String, dynamic> json) => RoadEventTypeConfigDto(
    type: json['type'] as String?,
    labelEn: json['labelEn'] as String?,
    labelAr: json['labelAr'] as String?,
    lanesEnabled: json['lanesEnabled'] as bool?,
  );
}
