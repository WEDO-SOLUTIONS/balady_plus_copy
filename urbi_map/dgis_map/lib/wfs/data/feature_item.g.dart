// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeatureItem _$FeatureItemFromJson(Map<String, dynamic> json) => FeatureItem(
      type: json['type'] as String,
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      properties:
          Properties.fromJson(json['properties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeatureItemToJson(FeatureItem instance) =>
    <String, dynamic>{
      'type': instance.type,
      'geometry': instance.geometry.toJson(),
      'properties': instance.properties.toJson(),
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

Properties _$PropertiesFromJson(Map<String, dynamic> json) => Properties(
      id: json['id'] as int,
      trackId: json['track_id'] as String,
      photoUrl: json['photo_url'] as String,
      azimuth: (json['azimuth'] as num).toDouble(),
      captureTime: DateTime.parse(json['capture_time'] as String),
      panoramic: json['panoramic'] as bool,
    );

Map<String, dynamic> _$PropertiesToJson(Properties instance) =>
    <String, dynamic>{
      'id': instance.id,
      'track_id': instance.trackId,
      'photo_url': instance.photoUrl,
      'azimuth': instance.azimuth,
      'capture_time': instance.captureTime.toIso8601String(),
      'panoramic': instance.panoramic,
    };
