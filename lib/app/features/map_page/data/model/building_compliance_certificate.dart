import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;

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
  final List<List<gm.LatLng>>? pathsGoogle;

  BuildingComplianceCertificate(
      {required this.paths,
      required id,
      required name,
      required type,
      required description,
      latLng,
      this.pathsGoogle,
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
          name: json['attributes']["DISTRICTNAME"] ?? 'name',
          description: json['attributes']["AMANANAME"] ?? 'description',
          type: json['attributes']["MUNICIPALITYNAME"] ?? 'type',
          PRIORITYAREA: json['attributes']["PRIORITYAREA"] ?? 'type',
          STARTDATE: json['attributes']["STARTDATE"] ?? 'type',
          TARGETBUILDINGTYPE:
              json['attributes']["TARGETBUILDINGTYPE"] ?? 'type',
          STAGENO: json['attributes']["STAGENO"] ?? 'type',
          AMANANAME: json['attributes']["AMANANAME"] ?? 'type',
          MUNICIPALITYNAME: json['attributes']["MUNICIPALITYNAME"] ?? 'type',
          DISTRICTNAME: json['attributes']["DISTRICTNAME"] ?? 'type',
          STREETTYPE: json['attributes']["STREETTYPE"] ?? 'type',
          STREETWIDTH: json['attributes']["STREETWIDTH"] ?? 'type',
          pathsGoogle: getGoogleList(json['geometry']["paths"]),
          ///////////////
          paths: getList(json['geometry']["paths"])

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
    return (MUNICIPALITYNAME ?? "") + "," + (DISTRICTNAME ?? "");
  }
}
