// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layer_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpatialReference _$SpatialReferenceFromJson(Map<String, dynamic> json) =>
    SpatialReference(
      json['wkid'] as int,
      json['latestWkid'] as int,
    );

Map<String, dynamic> _$SpatialReferenceToJson(SpatialReference instance) =>
    <String, dynamic>{
      'wkid': instance.wkid,
      'latestWkid': instance.latestWkid,
    };

ObjectGeometry _$ObjectGeometryFromJson(Map<String, dynamic> json) =>
    ObjectGeometry(
      ObjectGeometry._fromJson(json['x']),
      ObjectGeometry._fromJson(json['y']),
    );

Map<String, dynamic> _$ObjectGeometryToJson(ObjectGeometry instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };

LayerObject _$LayerObjectFromJson(Map<String, dynamic> json) => LayerObject(
      ObjectGeometry.fromJson(json['geometry'] as Map<String, dynamic>),
      json['attributes'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$LayerObjectToJson(LayerObject instance) =>
    <String, dynamic>{
      'geometry': instance.geometry.toJson(),
      'attributes': instance.attributes,
    };

LayerData _$LayerDataFromJson(Map<String, dynamic> json) => LayerData(
      (json['fields'] as List<dynamic>)
          .map((e) => FieldInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['geometryType'] as String,
      SpatialReference.fromJson(
          json['spatialReference'] as Map<String, dynamic>),
      (json['features'] as List<dynamic>)
          .map((e) => LayerObject.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LayerDataToJson(LayerData instance) => <String, dynamic>{
      'fields': instance.fields.map((e) => e.toJson()).toList(),
      'geometryType': instance.geometryType,
      'spatialReference': instance.spatialReference.toJson(),
      'features': instance.features.map((e) => e.toJson()).toList(),
    };
