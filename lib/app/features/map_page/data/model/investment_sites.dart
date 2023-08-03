import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<InvestmentSites> investmentSitesFromJson(List list) =>
    List<InvestmentSites>.from(list.map((x) => InvestmentSites.fromJson(x)));

class InvestmentSites extends PointLayersData {
  String? opportunityId;
  String? opportunityType;
  String? sourceCaseKEY;
  String? submunicapility;
  String? street;
  String? municipality;

  InvestmentSites({
    required id,
    required name,
    required type,
    required description,
    required latLng,
    this.municipality,
    this.opportunityId,
    this.opportunityType,
    this.sourceCaseKEY,
    this.street,
    this.submunicapility,
  }) : super(
            id: id,
            name: name,
            description: description,
            type: type,
            latLng: latLng);

  factory InvestmentSites.fromJson(Map<String, dynamic> json) =>
      InvestmentSites(
        id: json['attributes']["OBJECTID"].toString(),
        name: json['attributes']["CONTRACTNAME"] ?? '',
        description: json['attributes']["OPPORTUNITYDESCRIPTION"] ?? '',
        type: json['attributes']["INVESTTYPE"]?.toString() ?? '',
        municipality: json['attributes']["MUNICIPALITY_ID"],
        sourceCaseKEY: json['attributes']["SOURCECASEKEY"],
        street: json['attributes']["SITEADDRESS"],
        submunicapility: json['attributes']["SUBMUNICIPALITY"],
        opportunityId: json['attributes']["PYID"],
        opportunityType: json['attributes']["TYPE"],
        latLng: GeoPointWithElevationMessage(
          elevation: 1,
          latitude: double.parse(json['geometry']["y"].toString()),
          longitude: double.parse(json['geometry']["x"].toString()),
        ),
      );
}
