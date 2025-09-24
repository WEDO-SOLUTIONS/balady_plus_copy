part of 'bss_payload.dart';

/// Marker size
enum BssMarkerSize { small, medium, large }

/// Description of the marker on the map
class BssMapMarker {
  const BssMapMarker({
    this.scale,
    this.adsHighlight,
    this.isWorking,
    this.isDeleted,
    this.hasDescription,
    this.rubricType,
  });

  /// Marker size
  final BssMarkerSize? scale;

  /// An indication that a marker has an advertising highlight.
  final bool? adsHighlight;

  /// Describes whether the branch to which the marker belongs is currently operating.
  /// — if it is operating - true
  /// — if not - false
  /// not sent if there is no data on the branch's operation.
  final bool? isWorking;

  /// Describes whether the card to which the marker belongs has been deleted.
  /// — if deleted - true
  /// — if not - false
  /// not sent if no data.
  final bool? isDeleted;

  /// Availability of description in marker:
  /// — if description is present - true
  /// — if absent - false
  final bool? hasDescription;

  /// Description of the heading on the marker, if any
  final String? rubricType;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'scale': scale?.name,
    };
    if (adsHighlight != null) {
      data['adsHighlight'] = adsHighlight;
    }
    if (isWorking != null) {
      data['isWorking'] = isWorking;
    }
    if (isDeleted != null) {
      data['isDeleted'] = isDeleted;
    }
    if (hasDescription != null) {
      data['hasDescription'] = hasDescription;
    }
    if (rubricType != null) {
      data['rubricType'] = rubricType;
    }
    return data;
  }
}
