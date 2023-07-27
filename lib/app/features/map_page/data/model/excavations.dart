import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<Excavations> excavationsFromJson(List list) =>
    List<Excavations>.from(list.map((x) => Excavations.fromJson(x)));

class Excavations extends PointLayersData {
  final String contractorName;
  final String startDate;
  final String endDate;
  final GeoPointMessage startPoint;
  final GeoPointMessage endPoint;
  final List<GeoPointMessage> paths;

  Excavations({
    required this.contractorName,
    required this.startDate,
    required this.endDate,
    required this.startPoint,
    required this.endPoint,
    required this.paths,
    required id,
    required name,
    required type,
    required description,
    required latLng,
  }) : super(
          id: id,
          name: name,
          description: description,
          type: type,
          latLng: latLng,
        );

  factory Excavations.fromJson(Map<String, dynamic> json) => Excavations(
        id: json['attributes']["OBJECTID"].toString(),
        name: json['attributes']["PROJECT_NAME"] ?? 'name',
        description: json['attributes']["PROJECT_DESC"] ?? 'description',
        type: json['attributes']["SERVTYPE"] ?? 'type',
        latLng: GeoPointMessage(
          latitude:
              double.parse(json['attributes']["START_POINT_X"].toString()),
          longitude:
              double.parse(json['attributes']["START_POINT_Y"].toString()),
        ),
        /////////////////////////
        contractorName:
            json['attributes']["CONTRACTOR_NAME"] ?? 'contractorName',
        startDate: json['attributes']["startDate"] ?? 'startDate',
        endDate: json['attributes']["endDate"] ?? 'endDate',
        startPoint: GeoPointMessage(
          latitude:
              double.parse(json['attributes']["START_POINT_X"].toString()),
          longitude:
              double.parse(json['attributes']["START_POINT_Y"].toString()),
        ),
        endPoint: GeoPointMessage(
          latitude: double.parse(json['attributes']["END_POINT_X"].toString()),
          longitude: double.parse(json['attributes']["END_POINT_Y"].toString()),
        ),
        paths: getList(json['geometry']["paths"]), // not tested yat
      );
}

List<GeoPointMessage> getList(List list) {
  final List<GeoPointMessage> paths = [];
  for (var pointList in list) {
    for (var point in pointList) {
      paths.add(
        GeoPointMessage(
          latitude: double.parse(point[1].toString()),
          longitude: double.parse(point[0].toString()),
        ),
      );
    }
  }
  return paths;
}