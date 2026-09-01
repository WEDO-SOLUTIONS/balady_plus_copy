import 'package:mapness/features/road_events/domain/road_event.dart';

/// Hand-written, defensive parsing (rather than `json_serializable`) matching a
/// real Road Event Service response captured from `POST /events`. Some value
/// sets aren't fully documented (e.g. `status` values beyond `"active"`,
/// `feedback.*.reason` codes beyond `"not_authenticated"`), so those are kept
/// as raw strings instead of being enumerated.
class RoadEventResponseDto {
  const RoadEventResponseDto({
    required this.id,
    required this.type,
    required this.location,
    required this.lanes,
    required this.feedback,
    required this.status,
    required this.reportCount,
    required this.stillThereCount,
    required this.notAnymoreCount,
    required this.affectsRouting,
    required this.affectsMap,
    required this.isOwnEvent,
    this.createdAt,
    this.expiresAt,
    this.updatedAt,
  });

  final String id;
  final RoadEventType type;
  final RoadEventLocation location;
  final Set<RoadEventLane> lanes;
  final RoadEventFeedback feedback;
  final String status;
  final int reportCount;
  final int stillThereCount;
  final int notAnymoreCount;
  final bool affectsRouting;
  final bool affectsMap;
  final bool isOwnEvent;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final DateTime? updatedAt;

  static RoadEventResponseDto? fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final eventType = json['type'] as String?;
    final position = json['position'] as Map<String, dynamic>?;
    final lat = (position?['lat'] as num?)?.toDouble();
    final lng = (position?['lon'] as num?)?.toDouble();
    if (id == null || eventType == null || lat == null || lng == null) {
      return null;
    }

    final lanesJson = json['lanes'] as List? ?? const [];
    final lanes = lanesJson.map(RoadEventLane.fromApiValue).whereType<RoadEventLane>().toSet();

    return RoadEventResponseDto(
      id: id,
      type: RoadEventType.fromApiValue(eventType),
      location: RoadEventLocation(latitude: lat, longitude: lng),
      lanes: lanes,
      feedback: _feedbackFromJson(json['feedback'] as Map<String, dynamic>?),
      status: json['status'] as String? ?? 'active',
      reportCount: (json['reportCount'] as num?)?.toInt() ?? 0,
      stillThereCount: (json['stillThereCount'] as num?)?.toInt() ?? 0,
      notAnymoreCount: (json['notAnymoreCount'] as num?)?.toInt() ?? 0,
      affectsRouting: json['affectsRouting'] as bool? ?? false,
      affectsMap: json['affectsMap'] as bool? ?? false,
      isOwnEvent: json['isOwnEvent'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      expiresAt: DateTime.tryParse(json['expiresAt'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['lastUpdateAt'] as String? ?? ''),
    );
  }

  static RoadEventFeedback _feedbackFromJson(Map<String, dynamic>? json) => RoadEventFeedback(
    stillThere: _feedbackAvailabilityFromJson(json?['stillThere'] as Map<String, dynamic>?),
    notAnymore: _feedbackAvailabilityFromJson(json?['notAnymore'] as Map<String, dynamic>?),
  );

  static RoadEventFeedbackAvailability _feedbackAvailabilityFromJson(Map<String, dynamic>? json) =>
      RoadEventFeedbackAvailability(allowed: json?['allowed'] as bool? ?? false, reason: json?['reason'] as String?);

  RoadEvent toDomain() => RoadEvent(
    id: id,
    type: type,
    location: location,
    lanes: lanes,
    feedback: feedback,
    status: status,
    reportCount: reportCount,
    stillThereCount: stillThereCount,
    notAnymoreCount: notAnymoreCount,
    affectsRouting: affectsRouting,
    affectsMap: affectsMap,
    isOwnEvent: isOwnEvent,
    createdAt: createdAt,
    expiresAt: expiresAt,
    updatedAt: updatedAt,
  );
}
