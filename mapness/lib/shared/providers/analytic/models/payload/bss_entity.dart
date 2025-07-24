import 'package:mapness/shared/providers/analytic/models/extensions/type_defs.dart';

class BssEntity {
  const BssEntity({
    required this.id,
    required this.type,
    this.subtype,
    // TODO: Check if this is should not be here
    this.segmentInfo,
  });

  /// Unique stable identifier of the object.
  /// Numeric identifier of the object in the database (company, building, meta-heading, pseudo-heading, heading) or UUID of a photo, collection, review, video, etc.
  final BssEntityId id;

  /// The name of the object type corresponding to the type field from the general object structure.
  final String type;

  /// The subtype of the object type corresponding to the subtype field from the general object structure.
  final String? subtype;

  /// Segment information
  final BssSegmentInfo? segmentInfo;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'type': type,
    };
    if (subtype != null) {
      data['subtype'] = subtype;
    }
    if (segmentInfo != null) {
      data['segmentInfo'] = segmentInfo!.toJson();
    }
    return data;
  }
}

/// Segment information
class BssSegmentInfo {
  const BssSegmentInfo({
    required this.segmentId,
  });

  /// Unique stable identifier of the geography segment (in particular, it can be the identifier of the current project from the List of projects)
  /// String representation of a number from 1 to 19 digits (max: 9223372036854775807)
  final BssStringId segmentId;

  Map<String, dynamic> toJson() => {
        'segmentId': segmentId,
      };
}
