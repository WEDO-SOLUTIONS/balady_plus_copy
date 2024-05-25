enum PathCardStatusPriority {
  critical,
  warning,
  info,
}

enum PathCardStatusType {
  shortest,
  overlaps,
  paid,
  incline,
}

class PathCardStatus {
  final String text;
  final PathCardStatusPriority priority;
  final PathCardStatusType type;

  const PathCardStatus._({
    required this.text,
    required this.priority,
    required this.type,
  });

  factory PathCardStatus.shortest(String localizedText) => PathCardStatus._(
        text: localizedText,
        priority: PathCardStatusPriority.warning,
        type: PathCardStatusType.shortest,
      );

  factory PathCardStatus.overlaps(String localizedText) => PathCardStatus._(
        text: localizedText,
        priority: PathCardStatusPriority.critical,
        type: PathCardStatusType.overlaps,
      );

  factory PathCardStatus.paid(String localizedText) => PathCardStatus._(
        text: localizedText,
        priority: PathCardStatusPriority.warning,
        type: PathCardStatusType.paid,
      );

  factory PathCardStatus.incline(String localizedText) => PathCardStatus._(
        text: localizedText,
        priority: PathCardStatusPriority.info,
        type: PathCardStatusType.incline,
      );
}
