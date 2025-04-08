import 'package:dgis_map/library.dart';


import 'package:smart_advisor/app/features/map/data/models/point_layers_data.dart';

List<BuildingComplianceCertificate> buildingComplianceCertificateFromJson(
        List list) =>
    List<BuildingComplianceCertificate>.from(
        list.map((x) => BuildingComplianceCertificate.fromJson(x)));

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

  BuildingComplianceCertificate(
      {required this.paths,
      required id,
      required name,
      required type,
      required description,
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
      this.TARGETBUILDINGTYPE})
      : super(
          id: id,
          name: name,
          description: description,
          type: type,
          latLng: latLng,
        );

  factory BuildingComplianceCertificate.fromJson(Map<String, dynamic> json) =>
      BuildingComplianceCertificate(
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
          paths: getList(json['geometry']["paths"]));
  String getMunAndDis() {
    return "${MUNICIPALITYNAME ?? ""},${DISTRICTNAME ?? ""}";
  }

  String getStreetName() {
    return STREETNAME ?? "";
  }
}
