// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layer_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldInfo _$FieldInfoFromJson(Map<String, dynamic> json) => FieldInfo(
      json['name'] as String,
      json['type'] as String,
      json['alias'] as String,
    );

Map<String, dynamic> _$FieldInfoToJson(FieldInfo instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'alias': instance.alias,
    };

LayerInfo _$LayerInfoFromJson(Map<String, dynamic> json) => LayerInfo(
      json['id'] as int,
      json['name'] as String,
      json['geometryType'] as String,
      (json['fields'] as List<dynamic>)
          .map((e) => FieldInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      FieldInfo.fromJson(json['geometryField'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LayerInfoToJson(LayerInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'geometryType': instance.geometryType,
      'fields': instance.fields.map((e) => e.toJson()).toList(),
      'geometryField': instance.geometryField.toJson(),
    };
