

import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../facility_qr/data/qr_details_response.dart';

class SurveyInqueryData {
  int? licenseId;
  String? oldLicenseId;
  String? licenseIssueDate;
  int? purposeId;
  String? purposeName;
  int? mainBuildingClassId;
  String? mainBuildingClassName;
  int? subBuildingClassId;
  String? subBuildingClassName;
  List<Parcel>? parcels;
  int? municipalityId;
  String? municipalityName;
  int? subMunicipalityId;
  String? subMunicipalityName;
  int? districtId;
  String? districtName;
  String? mapNumber;

  SurveyInqueryData({
    this.licenseId,
    this.oldLicenseId,
    this.licenseIssueDate,
    this.purposeId,
    this.purposeName,
    this.mainBuildingClassId,
    this.mainBuildingClassName,
    this.subBuildingClassId,
    this.subBuildingClassName,
    this.parcels,
    this.municipalityId,
    this.municipalityName,
    this.subMunicipalityId,
    this.subMunicipalityName,
    this.districtId,
    this.districtName,
    this.mapNumber,
  });


}


class Parcel {
  int? id;
  int? area;
  int? areaAccordingToScheme;
  String? landNo;

  Parcel({
    this.id,
    this.area,
    this.areaAccordingToScheme,
    this.landNo,
  });

}




