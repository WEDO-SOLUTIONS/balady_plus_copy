import 'package:dgis_map/library.dart';

class EsriPointFeature {
  EsriPointFeature(this.attributes, this.point, this.layerId);

  final Map<String, dynamic> attributes;
  final GeoPointWithElevationMessage point;
  final String layerId;

  factory EsriPointFeature.fromJson(
      Map<String, dynamic> json, String layerId) =>
      EsriPointFeature(
        json["attributes"],
        GeoPointWithElevationMessage(
          latitude: json["geometry"]["y"],
          longitude: json["geometry"]["x"],
          elevation: 0,
        ),
        layerId,
      );
}