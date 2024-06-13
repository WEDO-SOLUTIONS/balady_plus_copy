import 'package:dgis_map/library.dart';

class SuggestHistory {
  GeoPointWithElevationMessage markerPosition;
  DgisObjectIdMessage id;

  String title, subtitle;

  SuggestHistory({
    required this.markerPosition,
    required this.id,
    required this.title,
    required this.subtitle,
  });

  factory SuggestHistory.fromJson(Map<String, dynamic> json) => SuggestHistory(
        markerPosition: GeoPointWithElevationMessage(
          longitude: json["markerPosition"]['latitude'],
          latitude: json["markerPosition"]['latitude'],
          elevation: json["markerPosition"]['elevation'],
        ),
        id: DgisObjectIdMessage(
          objectId: json['id']['objectId'],
          entranceId: json['id']['objectId'],
        ),
        title: json['title'] ?? '',
        subtitle: json['subtitle'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "markerPosition": {
          'latitude': markerPosition.latitude,
          'longitude': markerPosition.longitude,
          'elevation': markerPosition.elevation,
        },
        "id": {
          'objectId': id.objectId,
          'entranceId': id.entranceId,
        },
        'subtitle': subtitle,
        'title': title,
      };
}
