import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../facility_qr/data/qr_details_response.dart';
import '../../../survey_license_inquery_report/domain/entity/survey_inquery_data_entity.dart';

class ConstructionLicenseData {
  int? licenseId;
  String? oldLicenseId; //null
  String? licenseIssueDate;
  int? statusId;
  String? statusName;
  int? licenseType;
  int? buildingTypeId;
  String? buildingTypeName;
  SurveyReport? surveyReport;
  String? licenseIssueDateDesc;
  String? x;
  String? y;

  ConstructionLicenseData({
    this.licenseId,
    this.oldLicenseId,
    this.licenseIssueDate,
    this.licenseIssueDateDesc,
    this.statusId,
    this.statusName,
    this.licenseType,
    this.buildingTypeId,
    this.buildingTypeName,
    this.x,
    this.y,
    this.surveyReport,
  });
}

class SurveyReport {
  int? licenseId;
  String? oldLicenseId;
  String? licenseIssueDate;
  String? licenseIssueDateDesc;
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

  SurveyReport({
    this.licenseId,
    this.oldLicenseId,
    this.licenseIssueDate,
    this.licenseIssueDateDesc,
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
