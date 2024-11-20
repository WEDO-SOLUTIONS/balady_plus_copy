import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';

part 'rubric_marker_info.g.dart';

/// A class representing information about a typed marker.
///
/// This class contains the type of the marker and a set of rubric IDs associated with it.
/// Properties:
/// - [type]: The type of the marker, represented by [MapMarkersType].
/// - [rubricIds]: A set of rubric IDs associated with the marker.
@JsonSerializable()
class RubricMarkerInfo {
  final MapMarkersType type;
  final Set<int> rubricIds;

  const RubricMarkerInfo({
    required this.type,
    required this.rubricIds,
  });

  factory RubricMarkerInfo.fromJson(Map<String, dynamic> json) => _$RubricMarkerInfoFromJson(json);
}
