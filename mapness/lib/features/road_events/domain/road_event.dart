/// Domain model for the Road Event Service (REST) — decoupled from the 2GIS
/// SDK's `RoadEventType`/`RoadEventLane`/`RoadEventActionType`, which used a
/// different type/lane vocabulary tied to the native map bridge.
enum RoadEventType {
  accident,
  construction,
  camera,
  police,
  danger,
  congestion;

  static RoadEventType fromApiValue(String value) => switch (value) {
    'accident' => RoadEventType.accident,
    'congestion' => RoadEventType.congestion,
    'construction' => RoadEventType.construction,
    'police' => RoadEventType.police,
    'camera' => RoadEventType.camera,
    'danger' => RoadEventType.danger,
    _ => RoadEventType.danger,
  };

  String get apiValue => name;

  /// All event types collect a lanes selection in the report/details UI.
  bool get supportsLanes => true;
}

enum RoadEventLane {
  left,
  center,
  right;

  /// Defensive: the Road Event Service's Postman examples show `affectedLanes`
  /// as either numbers (`[1, 2]`) or lane names (`["middle", "right"]`).
  static RoadEventLane? fromApiValue(Object? value) {
    if (value is num) {
      return switch (value.toInt()) {
        1 => RoadEventLane.left,
        2 => RoadEventLane.center,
        3 => RoadEventLane.right,
        _ => null,
      };
    }
    if (value is String) {
      return switch (value.toLowerCase()) {
        'left' => RoadEventLane.left,
        'middle' || 'center' => RoadEventLane.center,
        'right' => RoadEventLane.right,
        _ => null,
      };
    }
    return null;
  }

  String get apiValue => switch (this) {
    RoadEventLane.left => 'left',
    RoadEventLane.center => 'middle',
    RoadEventLane.right => 'right',
  };
}

/// Feedback verdicts the details sheet can submit ("Still there" / "Not anymore").
enum RoadEventActionType {
  confirmation,
  disproof;

  String get verdict => switch (this) {
    RoadEventActionType.confirmation => 'still_there',
    RoadEventActionType.disproof => 'not_anymore',
  };
}

/// Whether a given feedback verdict can be submitted for an event, and why not
/// when it can't (e.g. `"not_authenticated"`). `reason` codes beyond the ones
/// observed so far aren't enumerated — the Road Event Service doesn't document
/// the full set.
class RoadEventFeedbackAvailability {
  const RoadEventFeedbackAvailability({required this.allowed, this.reason});

  final bool allowed;
  final String? reason;
}

class RoadEventFeedback {
  const RoadEventFeedback({required this.stillThere, required this.notAnymore});

  final RoadEventFeedbackAvailability stillThere;
  final RoadEventFeedbackAvailability notAnymore;

  RoadEventFeedbackAvailability forType(RoadEventActionType type) => switch (type) {
    RoadEventActionType.confirmation => stillThere,
    RoadEventActionType.disproof => notAnymore,
  };

  Set<RoadEventActionType> get availableActionTypes => {
    if (stillThere.allowed) RoadEventActionType.confirmation,
    if (notAnymore.allowed) RoadEventActionType.disproof,
  };
}

class RoadEventLocation {
  const RoadEventLocation({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class RoadEvent {
  const RoadEvent({
    required this.id,
    required this.type,
    required this.location,
    required this.lanes,
    required this.feedback,
    this.status = 'active',
    this.reportCount = 0,
    this.stillThereCount = 0,
    this.notAnymoreCount = 0,
    this.affectsRouting = false,
    this.affectsMap = false,
    this.isOwnEvent = false,
    this.createdAt,
    this.expiresAt,
    this.updatedAt,
  });

  final String id;
  final RoadEventType type;
  final RoadEventLocation location;
  final Set<RoadEventLane> lanes;
  final RoadEventFeedback feedback;

  /// Raw status string (only `"active"` confirmed so far) — kept unenumerated
  /// since the full set of values isn't documented.
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
}

/// Client-side tunables from `GET /config` (Road Event Service). Only the
/// fields consumed by the client so far are kept here — the full response is
/// captured in `RoadEventConfigResponseDto`.
class RoadEventConfig {
  const RoadEventConfig({
    required this.feedbackCardDismissSeconds,
    required this.corridorWidthMeters,
    required this.pollIntervalSeconds,
  });

  /// Fallback when `/config` is unreachable or a field is missing — matches
  /// the values hardcoded before this config was wired in.
  static const int defaultFeedbackCardDismissSeconds = 5;
  static const double defaultCorridorWidthMeters = 100;
  static const int defaultPollIntervalSeconds = 30;

  /// Floor for `pollIntervalSeconds` — guards against an anomalous `0`/negative
  /// value from the backend spinning the delta-sync `Timer.periodic` too fast.
  static const int minPollIntervalSeconds = 15;

  static const fallback = RoadEventConfig(
    feedbackCardDismissSeconds: defaultFeedbackCardDismissSeconds,
    corridorWidthMeters: defaultCorridorWidthMeters,
    pollIntervalSeconds: defaultPollIntervalSeconds,
  );

  final int feedbackCardDismissSeconds;
  final double corridorWidthMeters;
  final int pollIntervalSeconds;

  Duration get feedbackCardDismissDuration => Duration(seconds: feedbackCardDismissSeconds);
  Duration get pollInterval => Duration(seconds: pollIntervalSeconds);
}
