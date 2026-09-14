import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<InvestmentSites> investmentSitesFromJson(List list) =>
    List<InvestmentSites>.from(list.map((x) => InvestmentSites.fromJson(x)));

class InvestmentSites extends PointLayersData {
  String? PYID;
  String? STATUS;
  String? OPPORTUNITYNUMBER;
  String? ID;
  dynamic DOCUMENTVALUE;
  dynamic DAILYLEASECOST;
  String? TYPE;
  String? OPPORTUNITYDESCRIPTION;
  String? SITENUMBER;
  String? BIDENDDATE;
  String? SITEADDRESS;
  dynamic SITEAREA;
  String? MAIN_ACTIVITY_NAME;
  String? SUB_ACTIVITY_NAME;
  String? LOCATIONLISTSTRING;
  dynamic DATEOFOPENENVELOPES;
  dynamic ANNOUNCEMENTDATE;
  dynamic RFPENDDATE;
  dynamic RENTALENDDATE;
  dynamic RENTALSTARTDATE;
  String? REGION_ID;
  String? AMANA_ID;
  String? MUNICIPALITY_ID;
  String? SUBMUNICIPALITY_ID;

  InvestmentSites({
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    this.SITEAREA,
    required super.latLng,
    this.PYID,
    this.STATUS,
    this.OPPORTUNITYNUMBER,
    this.ID,
    this.DOCUMENTVALUE,
    this.DAILYLEASECOST,
    this.TYPE,
    this.OPPORTUNITYDESCRIPTION,
    this.SITENUMBER,
    this.BIDENDDATE,
    this.SITEADDRESS,
    this.MAIN_ACTIVITY_NAME,
    this.SUB_ACTIVITY_NAME,
    this.LOCATIONLISTSTRING,
    this.DATEOFOPENENVELOPES,
    this.ANNOUNCEMENTDATE,
    this.RFPENDDATE,
    this.RENTALENDDATE,
    this.RENTALSTARTDATE,
    this.REGION_ID,
    this.AMANA_ID,
    this.MUNICIPALITY_ID,
    this.SUBMUNICIPALITY_ID,
  });

  factory InvestmentSites.fromJson(Map<String, dynamic> json) => InvestmentSites(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["CONTRACTNAME"] ?? '',
    description: json['attributes']["OPPORTUNITYDESCRIPTION"] ?? '',
    type: json['attributes']["INVESTTYPE"]?.toString() ?? '',
    PYID: json['attributes']["PYID"] ?? '',
    SITEAREA: json['attributes']["SITEAREA"] ?? '',
    STATUS: json['attributes']["STATUS"] ?? '',
    OPPORTUNITYNUMBER: json['attributes']["OPPORTUNITYNUMBER"] ?? '',
    ID: json['attributes']["ID"] ?? '',
    DOCUMENTVALUE: json['attributes']["DOCUMENTVALUE"] ?? '',
    DAILYLEASECOST: json['attributes']["DAILYLEASECOST"] ?? '',
    TYPE: json['attributes']["TYPE"] ?? '',
    OPPORTUNITYDESCRIPTION: json['attributes']["OPPORTUNITYDESCRIPTION"] ?? '',
    SITENUMBER: json['attributes']["SITENUMBER"] ?? '',
    BIDENDDATE: json['attributes']["BIDENDDATE"] ?? '',
    SITEADDRESS: json['attributes']["SITEADDRESS"] ?? '',
    MAIN_ACTIVITY_NAME: json['attributes']["MAIN_ACTIVITY_NAME"] ?? '',
    SUB_ACTIVITY_NAME: json['attributes']["SUB_ACTIVITY_NAME"] ?? '',
    LOCATIONLISTSTRING: json['attributes']["LOCATIONLISTSTRING"] ?? '',
    DATEOFOPENENVELOPES: json['attributes']["DATEOFOPENENVELOPES"] ?? '',
    ANNOUNCEMENTDATE: json['attributes']["ANNOUNCEMENTDATE"] ?? '',
    RFPENDDATE: json['attributes']["RFPENDDATE"] ?? '',
    RENTALENDDATE: json['attributes']["RENTALENDDATE"] ?? '',
    RENTALSTARTDATE: json['attributes']["RENTALSTARTDATE"] ?? '',
    REGION_ID: json['attributes']["REGION_ID"] ?? '',
    AMANA_ID: json['attributes']["AMANA_ID"] ?? '',
    MUNICIPALITY_ID: json['attributes']["MUNICIPALITY_ID"] ?? '',
    SUBMUNICIPALITY_ID: json['attributes']["SUBMUNICIPALITY_ID"] ?? '',
    latLng: GeoPointWithElevationMessage(
      elevation: 1,
      latitude: double.parse(json['geometry']["y"].toString()),
      longitude: double.parse(json['geometry']["x"].toString()),
    ),
  );
}
