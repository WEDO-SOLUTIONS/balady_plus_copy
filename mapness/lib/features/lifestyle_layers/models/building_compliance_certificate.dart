import 'package:dgis_map/library.dart';
import 'package:mapness/features/lifestyle_layers/models/map_enums.dart';
import 'package:mapness/features/lifestyle_layers/models/point_layers_data.dart';

List<BuildingComplianceCertificate> buildingComplianceCertificateFromJson(List list) =>
    List<BuildingComplianceCertificate>.from(
      list.map(
        (e) => BuildingComplianceCertificate.fromJson(e as Map<String, dynamic>),
      ),
    );

class BuildingComplianceCertificate extends PointLayersData {
  final List<GeoPointMessage> paths;
  final String? priorityArea;
  final String? startDate;
  final String? targetBuildingType;
  final String? stageno;
  final String? amananme;
  final String? municipalityName;
  final String? districtName;
  final String? streetType;
  final String? streetWidth;
  final String? streetName;
  final List<List<GeoPointMessage>>? pathsGoogle;

  const BuildingComplianceCertificate({
    required this.paths,
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    super.latLng,
    this.pathsGoogle,
    this.streetName,
    this.amananme,
    this.districtName,
    this.municipalityName,
    this.priorityArea,
    this.stageno,
    this.startDate,
    this.streetType,
    this.streetWidth,
    this.targetBuildingType,
  }) : super(layerType: GISMapLayers.bsAimtithalBuildingsCertificateL);

  factory BuildingComplianceCertificate.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>;
    // ignore: avoid_dynamic_calls
    final paths = json['geometry']['paths'];
    return BuildingComplianceCertificate(
      id: attributes['OBJECTID'].toString(),
      name: attributes['DISTRICTNAME'] ?? '',
      description: attributes['AMANANAME'] ?? '',
      type: attributes['MUNICIPALITYNAME'] ?? '',
      streetName: attributes['STREETNAME'] ?? '',
      priorityArea: attributes['PRIORITYAREA'] ?? '',
      startDate: attributes['STARTDATE'] ?? '',
      targetBuildingType: attributes['TARGETBUILDINGTYPE'] ?? '',
      stageno: attributes['STAGENO'] ?? '',
      amananme: attributes['AMANANAME'] ?? '',
      municipalityName: attributes['MUNICIPALITYNAME'] ?? '',
      districtName: attributes['DISTRICTNAME'] ?? '',
      streetType: attributes['STREETTYPE'] ?? '',
      streetWidth: attributes['STREETWIDTH'] ?? '',
      pathsGoogle: getGoogleList(paths),
      paths: getList(paths),
    );
  }

  String getMunAndDis() => "${municipalityName ?? ""},${districtName ?? ""}";

  String getStreetName() => streetName ?? '';
}
