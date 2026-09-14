import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<BuildingComplianceCertificate> buildingComplianceCertificateFromJson(List list) =>
    List<BuildingComplianceCertificate>.from(list.map((x) => BuildingComplianceCertificate.fromJson(x)));

class BuildingComplianceCertificate extends PointLayersData {
  final List<GeoPointMessage> paths;
  String? PRIORITYAREA;
  String? STARTDATE;
  String? TARGETBUILDINGTYPE;
  String? STAGENO;
  String? AMANANAME;
  String? MUNICIPALITYNAME;
  String? DISTRICTNAME;
  String? STREETTYPE;
  String? STREETWIDTH;
  String? STREETNAME;
  final List<List<GeoPointMessage>>? pathsGoogle;

  BuildingComplianceCertificate({
    required this.paths,
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    latLng,
    this.pathsGoogle,
    this.STREETNAME,
    this.AMANANAME,
    this.DISTRICTNAME,
    this.MUNICIPALITYNAME,
    this.PRIORITYAREA,
    this.STAGENO,
    this.STARTDATE,
    this.STREETTYPE,
    this.STREETWIDTH,
    this.TARGETBUILDINGTYPE,
  });

  factory BuildingComplianceCertificate.fromJson(Map<String, dynamic> json) => BuildingComplianceCertificate(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["DISTRICTNAME"] ?? '',
    description: json['attributes']["AMANANAME"] ?? '',
    type: json['attributes']["MUNICIPALITYNAME"] ?? '',
    STREETNAME: json['attributes']["STREETNAME"] ?? '',
    PRIORITYAREA: json['attributes']["PRIORITYAREA"] ?? '',
    STARTDATE: json['attributes']["STARTDATE"] ?? '',
    TARGETBUILDINGTYPE: json['attributes']["TARGETBUILDINGTYPE"] ?? '',
    STAGENO: json['attributes']["STAGENO"] ?? '',
    AMANANAME: json['attributes']["AMANANAME"] ?? '',
    MUNICIPALITYNAME: json['attributes']["MUNICIPALITYNAME"] ?? '',
    DISTRICTNAME: json['attributes']["DISTRICTNAME"] ?? '',
    STREETTYPE: json['attributes']["STREETTYPE"] ?? '',
    STREETWIDTH: json['attributes']["STREETWIDTH"] ?? '',
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
    return "${MUNICIPALITYNAME ?? ""},${DISTRICTNAME ?? ""}";
  }

  String getStreetName() {
    return STREETNAME ?? "";
  }
}
