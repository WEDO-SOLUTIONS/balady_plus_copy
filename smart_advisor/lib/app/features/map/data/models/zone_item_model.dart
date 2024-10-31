import '/app/features/map/domain/entities/zone_item.dart';

class ZoneItemModel extends ZoneItem {
  ZoneItemModel({
    super.guid,
    super.polygon,
  });

  factory ZoneItemModel.fromJson(Map<String, dynamic> json) => ZoneItemModel(
        guid: json["guid"],
        polygon: json["polygon"] == null
            ? null
            : PolygonModel.fromJson(json["polygon"]),
      );
}

class PolygonModel extends Polygon {
  PolygonModel({
    super.rings,
  });

  factory PolygonModel.fromJson(Map<String, dynamic> json) => PolygonModel(
        rings: json["rings"] == null
            ? []
            : List<List<List<double>>>.from(json["rings"]!.map((x) =>
                List<List<double>>.from(x.map(
                    (x) => List<double>.from(x.map((x) => x?.toDouble())))))),
      );

  Map<String, dynamic> toJson() => {
        "rings": rings == null
            ? []
            : List<dynamic>.from(rings!.map((x) => List<dynamic>.from(
                x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
      };
}
