import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<BuildingComplianceCertificate> buildingComplianceCertificateFromJson(List list) =>
    List<BuildingComplianceCertificate>.from(list.map((x) => BuildingComplianceCertificate.fromJson(x)));

class BuildingComplianceCertificate extends PointLayersData {
  final List<GeoPointMessage> paths;
  String? priorityArea;
  String? startDate;
  String? targetBuildingType;
  String? stageNo;
  String? amanaName;
  String? municipalityName;
  String? districtName;
  String? streetType;
  String? streetWIdTh;
  String? streetName;
  final List<List<GeoPointMessage>>? pathsGoogle;

  BuildingComplianceCertificate({
    required this.paths,
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    latLng,
    this.pathsGoogle,
    this.streetName,
    this.amanaName,
    this.districtName,
    this.municipalityName,
    this.priorityArea,
    this.stageNo,
    this.startDate,
    this.streetType,
    this.streetWIdTh,
    this.targetBuildingType,
  });

  factory BuildingComplianceCertificate.fromJson(Map<String, dynamic> json) => BuildingComplianceCertificate(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["DISTRICTNAME"] ?? '',
    description: json['attributes']["AMANANAME"] ?? '',
    type: json['attributes']["MUNICIPALITYNAME"] ?? '',
    streetName: json['attributes']["STREETNAME"] ?? '',
    priorityArea: json['attributes']["PRIORITYAREA"] ?? '',
    startDate: json['attributes']["STARTDATE"] ?? '',
    targetBuildingType: json['attributes']["TARGETBUILDINGTYPE"] ?? '',
    stageNo: json['attributes']["STAGENO"] ?? '',
    amanaName: json['attributes']["AMANANAME"] ?? '',
    municipalityName: json['attributes']["MUNICIPALITYNAME"] ?? '',
    districtName: json['attributes']["DISTRICTNAME"] ?? '',
    streetType: json['attributes']["STREETTYPE"] ?? '',
    streetWIdTh: json['attributes']["STREETWIDTH"] ?? '',
    pathsGoogle: getGoogleList(json['geometry']["paths"]),
    ///////////////
    paths: getList(json['geometry']["paths"]),

    /*paths: [
            GeoPointMessage(
                latitude: 26.369406393621627, longitude: 50.19933225597286),
            GeoPointMessage(
                latitude: 26.373032789329308, longitude: 50.19579384705713),
            GeoPointMessage(
                latitude: 26.373032789329308, longitude: 50.19579384705713),
            GeoPointMessage(
                latitude: 26.374354635533997, longitude: 50.19360020012975)
          ]*/

    // not tested yat
  );
  String getMunAndDis() {
    return "${municipalityName ?? ""},${districtName ?? ""}";
  }

  String getStreetName() {
    return streetName ?? "";
  }
}
