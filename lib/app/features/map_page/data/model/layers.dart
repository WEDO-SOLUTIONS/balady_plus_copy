import 'dart:convert';

List<Layers> layersFromJson(List list) => List<Layers>.from(list.map((x) => Layers.fromJson(x)));


class Layers {
  int id;
  String name;
  bool defaultVisibility;
  String type;
  String geometryType;

  Layers({
    required this.id,
    required this.name,
    required this.defaultVisibility,
    required this.type,
    required this.geometryType,
  });

  factory Layers.fromJson(Map<String, dynamic> json) => Layers(
    id: json["id"],
    name: json["name"],
    defaultVisibility: json["defaultVisibility"],
    type: json["type"],
    geometryType: json["geometryType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "defaultVisibility": defaultVisibility,
    "type": type,
    "geometryType": geometryType,
  };
}
