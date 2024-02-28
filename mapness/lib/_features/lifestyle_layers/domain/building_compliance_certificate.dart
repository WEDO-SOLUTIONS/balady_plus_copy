// ignore_for_file: argument_type_not_assignable
// ignore_for_file: avoid_dynamic_calls
// ignore_for_file: not_assigned_potentially_non_nullable_local_variable
import 'package:dgis_map/library.dart';
import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';
import 'package:mapness/_features/lifestyle_layers/domain/point_layers_data.dart';

List<BuildingComplianceCertificate> buildingComplianceCertificateFromJson(
  List list,
) =>
    List<BuildingComplianceCertificate>.from(
      list.map(BuildingComplianceCertificate.fromJson),
    );

class BuildingComplianceCertificate extends PointLayersData {
  BuildingComplianceCertificate({
    required this.paths,
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
    this.TARGETBUILDINGTYPE,
  }) : super(
          layerType: GISMapLayers.BSAimtithalBuildingsCertificateL,
          id: id,
          name: name,
          description: description,
          type: type,
          latLng: latLng,
        );

  factory BuildingComplianceCertificate.fromJson(Map<String, dynamic> json) =>
      BuildingComplianceCertificate(
        id: json['attributes']['OBJECTID'].toString(),
        name: json['attributes']['DISTRICTNAME'] ?? '',
        description: json['attributes']['AMANANAME'] ?? '',
        type: json['attributes']['MUNICIPALITYNAME'] ?? '',
        STREETNAME: json['attributes']['STREETNAME'] ?? '',
        PRIORITYAREA: json['attributes']['PRIORITYAREA'] ?? '',
        STARTDATE: json['attributes']['STARTDATE'] ?? '',
        TARGETBUILDINGTYPE: json['attributes']['TARGETBUILDINGTYPE'] ?? '',
        STAGENO: json['attributes']['STAGENO'] ?? '',
        AMANANAME: json['attributes']['AMANANAME'] ?? '',
        MUNICIPALITYNAME: json['attributes']['MUNICIPALITYNAME'] ?? '',
        DISTRICTNAME: json['attributes']['DISTRICTNAME'] ?? '',
        STREETTYPE: json['attributes']['STREETTYPE'] ?? '',
        STREETWIDTH: json['attributes']['STREETWIDTH'] ?? '',
        pathsGoogle: getGoogleList(json['geometry']['paths']),
        paths: getList(json['geometry']['paths']),
      );
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

  String getMunAndDis() => "${MUNICIPALITYNAME ?? ""},${DISTRICTNAME ?? ""}";

  String getStreetName() => STREETNAME ?? '';
}
