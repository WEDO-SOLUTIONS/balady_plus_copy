import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<InvestmentSites> investmentSitesFromJson(List list) =>
    List<InvestmentSites>.from(list.map((x) => InvestmentSites.fromJson(x)));

class InvestmentSites extends PointLayersData {
  String? pyid;
  String? status;
  String? opportunityNumber;
  String? objectId;
  dynamic documentValue;
  dynamic dailyleasecost;
  String? objectType;
  String? opportunityDescription;
  String? siteNumber;
  String? bIdEndDate;
  String? siteAddress;
  dynamic siteArea;
  String? mainActivityName;
  String? subActivityName;
  String? locationliststring;
  dynamic dateOfopenenvelopes;
  dynamic anNoUncementDate;
  dynamic rfpendDate;
  dynamic rentalendDate;
  dynamic rentalstartDate;
  String? regionId;
  String? amanaId;
  String? municipalityId;
  String? subMunicipalityId;

  InvestmentSites({
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    this.siteArea,
    required super.latLng,
    this.pyid,
    this.status,
    this.opportunityNumber,
    this.objectId,
    this.documentValue,
    this.dailyleasecost,
    this.objectType,
    this.opportunityDescription,
    this.siteNumber,
    this.bIdEndDate,
    this.siteAddress,
    this.mainActivityName,
    this.subActivityName,
    this.locationliststring,
    this.dateOfopenenvelopes,
    this.anNoUncementDate,
    this.rfpendDate,
    this.rentalendDate,
    this.rentalstartDate,
    this.regionId,
    this.amanaId,
    this.municipalityId,
    this.subMunicipalityId,
  });

  factory InvestmentSites.fromJson(Map<String, dynamic> json) => InvestmentSites(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["CONTRACTNAME"] ?? '',
    description: json['attributes']["OPPORTUNITYDESCRIPTION"] ?? '',
    type: json['attributes']["INVESTTYPE"]?.toString() ?? '',
    pyid: json['attributes']["PYID"] ?? '',
    siteArea: json['attributes']["SITEAREA"] ?? '',
    status: json['attributes']["STATUS"] ?? '',
    opportunityNumber: json['attributes']["OPPORTUNITYNUMBER"] ?? '',
    objectId: json['attributes']["ID"] ?? '',
    documentValue: json['attributes']["DOCUMENTVALUE"] ?? '',
    dailyleasecost: json['attributes']["DAILYLEASECOST"] ?? '',
    objectType: json['attributes']["TYPE"] ?? '',
    opportunityDescription: json['attributes']["OPPORTUNITYDESCRIPTION"] ?? '',
    siteNumber: json['attributes']["SITENUMBER"] ?? '',
    bIdEndDate: json['attributes']["BIDENDDATE"] ?? '',
    siteAddress: json['attributes']["SITEADDRESS"] ?? '',
    mainActivityName: json['attributes']["MAIN_ACTIVITY_NAME"] ?? '',
    subActivityName: json['attributes']["SUB_ACTIVITY_NAME"] ?? '',
    locationliststring: json['attributes']["LOCATIONLISTSTRING"] ?? '',
    dateOfopenenvelopes: json['attributes']["DATEOFOPENENVELOPES"] ?? '',
    anNoUncementDate: json['attributes']["ANNOUNCEMENTDATE"] ?? '',
    rfpendDate: json['attributes']["RFPENDDATE"] ?? '',
    rentalendDate: json['attributes']["RENTALENDDATE"] ?? '',
    rentalstartDate: json['attributes']["RENTALSTARTDATE"] ?? '',
    regionId: json['attributes']["REGION_ID"] ?? '',
    amanaId: json['attributes']["AMANA_ID"] ?? '',
    municipalityId: json['attributes']["MUNICIPALITY_ID"] ?? '',
    subMunicipalityId: json['attributes']["SUBMUNICIPALITY_ID"] ?? '',
    latLng: GeoPointWithElevationMessage(
      elevation: 1,
      latitude: double.parse(json['geometry']["y"].toString()),
      longitude: double.parse(json['geometry']["x"].toString()),
    ),
  );
}
