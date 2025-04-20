import 'package:dgis_map/library.dart';
import 'package:mapness/features/lifestyle_layers/models/map_enums.dart';
import 'package:mapness/features/lifestyle_layers/models/point_layers_data.dart';

List<InvestmentSites> investmentSitesFromJson(List list) => List<InvestmentSites>.from(
      list.map((e) => InvestmentSites.fromJson(e as Map<String, dynamic>)),
    );

class InvestmentSites extends PointLayersData {
  final String? pyId;
  final String? status;
  final String? opportunityNumber;
  final String? objectId;
  final String? documentValue;
  final String? dailyEaseCost;
  final String? objectType;
  final String? opportunityDescription;
  final String? siteNumber;
  final String? bidendDate;
  final String? siteAddress;
  final String? siteArea;
  final String? mainActivityName;
  final String? subActivityName;
  final String? locationListString;
  final String? dateOfOpenEnvelopes;
  final String? announcementDate;
  final String? rfpendDate;
  final String? rentalStartDate;
  final String? rentalEndDate;
  final String? regionId;
  final String? amanaId;
  final String? municipalityId;
  final String? subMunicipalityId;

  const InvestmentSites({
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    required super.latLng,
    this.siteArea,
    this.pyId,
    this.status,
    this.opportunityNumber,
    this.objectId,
    this.documentValue,
    this.dailyEaseCost,
    this.objectType,
    this.opportunityDescription,
    this.siteNumber,
    this.bidendDate,
    this.siteAddress,
    this.mainActivityName,
    this.subActivityName,
    this.locationListString,
    this.dateOfOpenEnvelopes,
    this.announcementDate,
    this.rfpendDate,
    this.rentalEndDate,
    this.rentalStartDate,
    this.regionId,
    this.amanaId,
    this.municipalityId,
    this.subMunicipalityId,
  }) : super(layerType: GISMapLayers.opportunities);

  factory InvestmentSites.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>;
    final geometry = json['geometry'] as Map<String, dynamic>;
    return InvestmentSites(
      id: attributes['OBJECTID'].toString(),
      name: attributes['CONTRACTNAME'] ?? '',
      description: attributes['OPPORTUNITYDESCRIPTION'] ?? '',
      type: attributes['INVESTTYPE']?.toString() ?? '',
      pyId: attributes['PYID'] ?? '',
      siteArea: attributes['SITEAREA']?.toString() ?? '',
      status: attributes['STATUS'] ?? '',
      opportunityNumber: attributes['OPPORTUNITYNUMBER'] ?? '',
      objectId: attributes['ID'] ?? '',
      documentValue: attributes['DOCUMENTVALUE']?.toString() ?? '',
      dailyEaseCost: attributes['DAILYLEASECOST']?.toString() ?? '',
      objectType: attributes['TYPE'] ?? '',
      opportunityDescription: attributes['OPPORTUNITYDESCRIPTION'] ?? '',
      siteNumber: attributes['SITENUMBER'] ?? '',
      bidendDate: attributes['BIDENDDATE'] ?? '',
      siteAddress: attributes['SITEADDRESS'] ?? '',
      mainActivityName: attributes['MAIN_ACTIVITY_NAME'] ?? '',
      subActivityName: attributes['SUB_ACTIVITY_NAME'] ?? '',
      locationListString: attributes['LOCATIONLISTSTRING'] ?? '',
      dateOfOpenEnvelopes: attributes['DATEOFOPENENVELOPES']?.toString() ?? '',
      announcementDate: attributes['ANNOUNCEMENTDATE']?.toString() ?? '',
      rfpendDate: attributes['RFPENDDATE']?.toString() ?? '',
      rentalEndDate: attributes['RENTALENDDATE']?.toString() ?? '',
      rentalStartDate: attributes['RENTALSTARTDATE']?.toString() ?? '',
      regionId: attributes['REGION_ID'] ?? '',
      amanaId: attributes['AMANA_ID'] ?? '',
      municipalityId: attributes['MUNICIPALITY_ID'] ?? '',
      subMunicipalityId: attributes['SUBMUNICIPALITY_ID'] ?? '',
      latLng: GeoPointWithElevationMessage(
        elevation: 1,
        latitude: double.parse(geometry['y'].toString()),
        longitude: double.parse(geometry['x'].toString()),
      ),
    );
  }
}
