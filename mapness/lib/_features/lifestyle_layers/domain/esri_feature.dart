import 'package:dgis_map/library.dart';
import 'package:mapness/_features/lifestyle_layers/domain/point_layers_data.dart';

class EsriPointFeature extends PointLayersData {
  EsriPointFeature({
    this.polygon,
    required this.point,
    required this.layerId,
    required this.objectId,
    required super.id,
    required super.name,
    required super.description,
    required super.type,
  });

  final GeoPointWithElevationMessage point;
  final PolygonOptionsMessage? polygon;
  final String layerId;
  final String objectId;

  factory EsriPointFeature.fromJson(Map<String, dynamic> json, String layerId) {
    var objectId = json["attributes"]?["OBJECTID"] ?? '';
    var geometry = json["geometry"];
    var latitude = geometry?["y"] ?? .0;
    var longitude = geometry?["x"] ?? .0;
    var rings = geometry['rings'];

    // var polygonOptionsMessage;
    // if (rings != null) {
    //   var list = rings as List<List<double>>;
    //
    //   try{
    //     var geoPointsList = list
    //         .map<GeoPointMessage>((e) {
    //
    //       return GeoPointMessage(
    //         latitude: doubles[0] as double,
    //         longitude: doubles[1] as double,
    //       );
    //     })
    //         .toList();
    //     polygonOptionsMessage = PolygonOptionsMessage(
    //       strokeWidth: 2,
    //       strokeColor: 0x26000000,
    //       color: 0xFF000000,
    //       contours: [geoPointsList],
    //     );
    //   }catch(e){
    //     debugPrint("POLYGON ERROR: $e");
    //   }
    // }
    return EsriPointFeature(
      // polygon: polygonOptionsMessage,
      objectId: '$objectId',
      layerId: layerId,
      point: GeoPointWithElevationMessage(
        latitude: latitude,
        longitude: longitude,
        elevation: 0,
      ),
      id: '',
      name: '',
      description: '',
      type: '',
    );
  }
}
