// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layer_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LayerCollection _$LayerCollectionFromJson(Map<String, dynamic> json) =>
    LayerCollection(
      (json['layers'] as List<dynamic>)
          .map((e) => LayerItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LayerCollectionToJson(LayerCollection instance) =>
    <String, dynamic>{
      'layers': instance.layers.map((e) => e.toJson()).toList(),
    };
