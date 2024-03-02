// ignore_for_file: argument_type_not_assignable
// ignore_for_file: avoid_dynamic_calls
// ignore_for_file: not_assigned_potentially_non_nullable_local_variable
import 'package:dgis_map/library.dart';

class SuggestHistory {
  SuggestHistory({
    required this.markerPosition,
    required this.id,
    required this.title,
    required this.subtitle,
  });

  factory SuggestHistory.fromJson(Map<String, dynamic> json) => SuggestHistory(
        markerPosition: GeoPointWithElevationMessage(
          longitude: json['markerPosition']['latitude'],
          latitude: json['markerPosition']['latitude'],
          elevation: json['markerPosition']['elevation'],
        ),
        id: DgisObjectIdMessage(
          objectId: json['id']['objectId'],
          entranceId: json['id']['objectId'],
        ),
        title: json['title'] ?? '',
        subtitle: json['subtitle'] ?? '',
      );
  GeoPointWithElevationMessage markerPosition;
  DgisObjectIdMessage id;

  String title;
  String subtitle;

  Map<String, dynamic> toJson() => {
        'markerPosition': {
          'latitude': markerPosition.latitude,
          'longitude': markerPosition.longitude,
          'elevation': markerPosition.elevation,
        },
        'id': {
          'objectId': id.objectId,
          'entranceId': id.entranceId,
        },
        'subtitle': subtitle,
        'title': title,
      };
}
