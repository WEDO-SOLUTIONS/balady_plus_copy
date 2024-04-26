import 'package:dgis_map/library.dart';

class SuggestHistory {
  final GeoPointWithElevationMessage markerPosition;
  final DgisObjectIdMessage id;
  final String title;
  final String subtitle;

  const SuggestHistory({
    required this.markerPosition,
    required this.id,
    required this.title,
    required this.subtitle,
  });

  factory SuggestHistory.fromJson(Map<String, dynamic> json) {
    final markerPosition = json['markerPosition'] as Map<String, dynamic>;
    // ignore: avoid_dynamic_calls
    final objectId = json['id']['objectId'] as int;

    return SuggestHistory(
      markerPosition: GeoPointWithElevationMessage(
        longitude: markerPosition['latitude'],
        latitude: markerPosition['latitude'],
        elevation: markerPosition['elevation'],
      ),
      id: DgisObjectIdMessage(
        objectId: objectId,
        entranceId: objectId,
      ),
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }

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
