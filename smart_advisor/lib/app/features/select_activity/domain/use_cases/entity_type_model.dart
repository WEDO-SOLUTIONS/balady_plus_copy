// To parse this JSON data, do
//
//     final entityType = entityTypeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<EntityType> entityTypeFromJson(String str) => List<EntityType>.from(json.decode(str).map((x) => EntityType.fromJson(x)));

String entityTypeToJson(List<EntityType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EntityType {
    String entityTypeName;
    String entityTypeImage;
    String id;

    EntityType({
        required this.entityTypeName,
        required this.entityTypeImage,
        required this.id,
    });

    EntityType copyWith({
        String? entityTypeName,
        String? entityTypeImage,
        String? id,
    }) => 
        EntityType(
            entityTypeName: entityTypeName ?? this.entityTypeName,
            entityTypeImage: entityTypeImage ?? this.entityTypeImage,
            id: id ?? this.id,
        );

    factory EntityType.fromJson(Map<String, dynamic> json) => EntityType(
        entityTypeName: json["entityTypeName"],
        entityTypeImage: json["entityTypeImage"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "entityTypeName": entityTypeName,
        "entityTypeImage": entityTypeImage,
        "id": id,
    };
}
