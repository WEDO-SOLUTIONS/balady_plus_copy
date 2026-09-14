import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<Excavations> excavationsFromJson(List list) => List<Excavations>.from(list.map((x) => Excavations.fromJson(x)));

class Excavations extends PointLayersData {
  /// final GeoPointMessage startPoint;
  ///final GeoPointMessage endPoint;
  final List<GeoPointMessage> paths;

  String? status;

  String? licStatus;
  String? nameAr;
  String? contractorName;
  String? projectName;
  DateTime? worksStartDate;
  DateTime? worksEndDate;
  String? streetCloseType;
  double? pathLength;
  String? siteName;
  String? workNature;
  //String? amana;
  //String? baladia;
  // String? districtName;
  //String? municipalityArName;

  Excavations({
    required this.paths,
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    latLng,
    this.status,
    this.licStatus,
    this.nameAr,
    this.contractorName,
    this.projectName,
    this.worksStartDate,
    this.worksEndDate,
    this.streetCloseType,
    this.pathLength,
    this.siteName,
    this.workNature,
    // this.amana,
    // this.baladia,
    //this.districtName,
    // this.municipalityArName
  });

  factory Excavations.fromJson(Map<String, dynamic> json) => Excavations(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["PROJECT_NAME"] ?? '',
    description: "",
    type: "",
    latLng: null,
    /* latLng: GeoPointMessage(
          latitude:
              double.parse(json['attributes']["START_POINT_X"].toString()),
          longitude:
              double.parse(json['attributes']["START_POINT_Y"].toString()),
        ),*/
    /////////////////////////
    contractorName: json['attributes']["CONTRACTOR_NAME"] ?? '',

    status: json['attributes']["STATUS"],

    nameAr: json['attributes']["NAME_AR"],
    projectName: json['attributes']["PROJECT_NAME"],

    licStatus: json['attributes']["LIC_STATUS"],

    worksStartDate: json['attributes']["WORKSTARTDATE"] != null
        ? DateTime.tryParse(json['attributes']["WORKSTARTDATE"])
        : null,

    worksEndDate: json['attributes']["WORKENDDATE"] != null
        ? DateTime.tryParse(json['attributes']["WORKENDDATE"])
        : null,
    streetCloseType: json['attributes']["STREET_CLOSE_TYPE"],
    pathLength: json['attributes']["PATHLENGTH"],
    siteName: json['attributes']["SITE_NAME"],

    workNature: json['attributes']["WORKNATURE"],

    /* amana: json['attributes']["AMMANA"],
 
        baladia: json['attributes']["BALADIA"],
        districtName: json['attributes']["DISTRICT_NAME"],

        municipalityArName: json['attributes']["MUNICIPALITYARNAME"],
*/
    /* startPoint: GeoPointMessage(
          latitude:
              double.parse(json['attributes']["START_POINT_X"].toString()),
          longitude:
              double.parse(json['attributes']["START_POINT_Y"].toString()),
        ),
        endPoint: GeoPointMessage(
          latitude: double.parse(json['attributes']["END_POINT_X"].toString()),
          longitude: double.parse(json['attributes']["END_POINT_Y"].toString()),
        ),*/
    paths: getList(json['geometry']["paths"]), // not tested yat
  );

  String getAddress() {
    return "";
    /*return (streetName ?? "") +
        ", " +
        (districtName ?? "") +
        ", " +
        (baladia ?? "") +
        ", " +
        (amana ?? "");*/
  }
}
