/// Priority of additional information on the path card.
///
/// We need to highlight information in the special way depending on its importance.
enum PathCardStatusPriority {
  critical,
  warning,
  info,
}

/// Type of additional information on the path card.
///
/// We restrict the types of additional information to make it easier to understand and manage in UI layer.
enum PathCardStatusType {
  shortest,
  overlaps,
  paid,
  incline,
}

/// Additional information on the path card.
///
/// If we want to highlight some information on the path card, we can use this class.
/// Amount of variations is limited to make it easier to understand and manage in UI layer.
class PathCardStatus {
  final String text;
  final PathCardStatusPriority priority;
  final PathCardStatusType type;

  const PathCardStatus._({
    required this.text,
    required this.priority,
    required this.type,
  });

  /// Additional information about the shortest path.
  factory PathCardStatus.shortest(String localizedText) => PathCardStatus._(
        text: localizedText,
        priority: PathCardStatusPriority.warning,
        type: PathCardStatusType.shortest,
      );

  /// Additional information about the path overlaps on the route.
  factory PathCardStatus.overlaps(String localizedText) => PathCardStatus._(
        text: localizedText,
        priority: PathCardStatusPriority.critical,
        type: PathCardStatusType.overlaps,
      );

  /// Additional information about the paid path.
  factory PathCardStatus.paid(String localizedText) => PathCardStatus._(
        text: localizedText,
        priority: PathCardStatusPriority.warning,
        type: PathCardStatusType.paid,
      );

  /// Additional information about the incline path.
  factory PathCardStatus.incline(String localizedText) => PathCardStatus._(
        text: localizedText,
        priority: PathCardStatusPriority.info,
        type: PathCardStatusType.incline,
      );
}
