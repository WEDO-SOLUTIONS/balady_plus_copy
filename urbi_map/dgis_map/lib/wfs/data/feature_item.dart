import 'package:json_annotation/json_annotation.dart';

part 'feature_item.g.dart';

@JsonSerializable(explicitToJson: true)
class FeatureItem {
  factory FeatureItem.fromJson(Map<String, dynamic> json) =>
      _$FeatureItemFromJson(json);

  const FeatureItem({
    required this.type,
    required this.geometry,
    required this.properties,
  });

  @JsonKey(name: "type")
  final String type;
  @JsonKey(name: "geometry")
  final Geometry geometry;
  @JsonKey(name: "properties")
  final Properties properties;

  Map<String, dynamic> toJson() => _$FeatureItemToJson(this);

  double get latitude => geometry.coordinates[0];
  double get longitude => geometry.coordinates[1];
}

@JsonSerializable()
class Geometry {
  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);

  Geometry({required this.type, required this.coordinates});

  @JsonKey(name: "type")
  final String type;
  @JsonKey(name: "coordinates")
  final List<double> coordinates;

  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable()
class Properties {
  factory Properties.fromJson(Map<String, dynamic> json) =>
      _$PropertiesFromJson(json);

  const Properties(
      {required this.id,
      required this.trackId,
      required this.photoUrl,
      required this.azimuth,
      required this.captureTime,
      required this.panoramic});

  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "track_id")
  final String trackId;
  @JsonKey(name: "photo_url")
  final String photoUrl;
  @JsonKey(name: "azimuth")
  final double azimuth;
  @JsonKey(name: "capture_time")
  final DateTime captureTime;
  @JsonKey(name: "panoramic")
  final bool panoramic;

  Map<String, dynamic> toJson() => _$PropertiesToJson(this);
}
