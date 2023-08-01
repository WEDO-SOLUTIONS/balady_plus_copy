import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<BuildingComplianceCertificate> buildingComplianceCertificateFromJson(
        List list) =>
    List<BuildingComplianceCertificate>.from(
        list.map((x) => BuildingComplianceCertificate.fromJson(x)));

class BuildingComplianceCertificate extends PointLayersData {
  final List<GeoPointMessage> paths;

  BuildingComplianceCertificate({
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

  factory BuildingComplianceCertificate.fromJson(Map<String, dynamic> json) =>
      BuildingComplianceCertificate(
        id: json['attributes']["OBJECTID"].toString(),
        name: json['attributes']["DISTRICTNAME"] ?? 'name',
        description: json['attributes']["AMANANAME"] ?? 'description',
        type: json['attributes']["MUNICIPALITYNAME"] ?? 'type',

        // not Have Center Point
        latLng: GeoPointMessage(
          latitude: 26.22,
          longitude: 46.4444,
        ),
        /////////////////////////
        paths: getList(json['geometry']["paths"]), // not tested yat
      );
}
