import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<Excavations> excavationsFromJson(List list) =>
    List<Excavations>.from(list.map((x) => Excavations.fromJson(x)));

class Excavations extends PointLayersData {
  final String contractorName;
  final String startDate;
  final String endDate;
  final LatLng startPoint;
  final LatLng endPoint;
  final List<List<double>> paths;

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
        id: json['attributes']["id"],
        name: json['attributes']["PROJECT_NAME"] ?? 'name',
        description: json['attributes']["PROJECT_DESC"] ?? 'description',
        type: json['attributes']["SERVTYPE"] ?? 'type',
        latLng: LatLng(
          latitude: json['attributes']["START_POINT_X"],
          longitude: json['attributes']["START_POINT_Y"],
        ),
        /////////////////////////
        contractorName:
            json['attributes']["CONTRACTOR_NAME"] ?? 'contractorName',
        startDate: json['attributes']["startDate"] ?? 'startDate',
        endDate: json['attributes']["endDate"] ?? 'endDate',
        startPoint: LatLng(
          latitude: json['attributes']["START_POINT_X"],
          longitude: json['attributes']["START_POINT_Y"],
        ),
        endPoint: LatLng(
          latitude: json['attributes']["END_POINT_X"],
          longitude: json['attributes']["END_POINT_Y"],
        ),
        paths: json['geometry']["paths"],
      );
}
