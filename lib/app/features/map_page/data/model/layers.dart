import 'package:equatable/equatable.dart';

List<Layers> layersFromJson(List list) => List<Layers>.from(list.map((x) => Layers.fromJson(x)));

class Layers extends Equatable {
  final int id;
  final String name;
  final bool defaultVisibility;
  final String type;
  final String geometryType;

  const Layers({
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

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, geometryType];
}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
List<SubLayers> subLayersFromJson(List list) => List<SubLayers>.from(list.map((x) => SubLayers.fromJson(x)));

class SubLayers {
  final String name;
  final String type;
  String url;
  String imageData;

  SubLayers({required this.name, required this.type, required this.url, required this.imageData});

  factory SubLayers.fromJson(Map<String, dynamic> json) => SubLayers(
    name: json["label"] ?? 'name',
    type: json['symbol']["type"] ?? '',
    url: json['symbol']["url"] ?? '',
    imageData: json['symbol']["imageData"] ?? '',
  );

  Map<String, dynamic> toJson() => {"name": name, "type": type, "url": url, "imageData": imageData};
}

enum GeometryType { esriGeometryPoint, esriGeometryPolyline, esriGeometryPolygon }
