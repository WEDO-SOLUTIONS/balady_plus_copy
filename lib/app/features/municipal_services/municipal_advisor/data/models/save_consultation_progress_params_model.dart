import 'package:equatable/equatable.dart';

class SaveConsultationProgressParamsModel extends Equatable {
  final String consultationKey;
  final String? subMunicipalityGisCode;
  final int? districtCode;
  final int? streetCode;
  final String longitude;
  final String latitude;
  final String? mapNo;
  final String? landNo;
  final num shopArea;
  final int activityId;
  final bool? atmFeesOption;
  final int? unitCount;
  final int? accommodationTypeId;
  final String? krokiUrl;

  const SaveConsultationProgressParamsModel({
    required this.consultationKey,
    required this.subMunicipalityGisCode,
    required this.districtCode,
    required this.streetCode,
    required this.longitude,
    required this.latitude,
    required this.mapNo,
    required this.landNo,
    required this.shopArea,
    required this.activityId,
    required this.atmFeesOption,
    required this.unitCount,
    required this.accommodationTypeId,
    required this.krokiUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "subMunicipalityGisCode": "013001002",
      "districtCode": 1010106,
      "streetCode": 1010106005,
      "latitude": "30.98431057991055",
      "longitude": "41.01233174244578",
      "mapNo": "مخطط أ/ب/1398",
      "landNo": "47",
      "shopArea": 546.0,
      "activityId": 849296,
      "atmFeesOption": null,
      "unitCount": null,
      "accommodationTypeId": null,
      "krokiUrl":
          "http://gisimages.momra.gov.sa/arcgis/rest/directories/arcgisoutput/Utilities/PrintingTools_GPServer/_ags_3a6b8c86-a7ab-11ed-b41b-00505685465c.jpg"
    };
  }

  @override
  List<Object?> get props => [
        consultationKey,
        subMunicipalityGisCode,
        districtCode,
        streetCode,
        longitude,
        latitude,
        mapNo,
        landNo,
        shopArea,
        activityId,
        atmFeesOption,
        unitCount,
        accommodationTypeId,
        krokiUrl,
      ];
}
