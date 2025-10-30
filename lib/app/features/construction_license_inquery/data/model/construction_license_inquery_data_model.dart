import '../../../survey_license_inquery_report/data/model/survey_inquery_data_model.dart';
import '../../domain/entity/construction_license_inquery_data_entity.dart';

class ConstructionLicenseDataModel extends ConstructionLicenseData {
  ConstructionLicenseDataModel({
    super.licenseId,
    super.oldLicenseId,
    super.licenseIssueDate,
    super.licenseIssueDateDesc,
    super.statusId,
    super.statusName,
    super.licenseType,
    super.buildingTypeId,
    super.buildingTypeName,
    super.x,
    super.y,
    super.surveyReport,
  });

  ConstructionLicenseDataModel.fromJson(dynamic json) {
    licenseId = json['licenseId'];
    oldLicenseId = json['oldLicenseId'];
    licenseIssueDate = json['licenseIssueDate'];
    licenseIssueDateDesc = json['licenseIssueDateDesc'];
    statusId = json['statusId'];
    statusName = json['statusName'];
    licenseType = json['licenseType'];
    buildingTypeId = json['buildingTypeId'];
    buildingTypeName = json['buildingTypeName'];
    x = json['x'];
    y = json['y'];
    surveyReport = json['surveyReport'] != null
        ? SurveyReportDataModel.fromJson(json['surveyReport'])
        : null;
  }
}

class SurveyReportDataModel extends SurveyReport {
  SurveyReportDataModel({
    super.licenseId,
    super.oldLicenseId,
    super.licenseIssueDate,
    super.licenseIssueDateDesc,
    super.purposeId,
    super.purposeName,
    super.mainBuildingClassId,
    super.mainBuildingClassName,
    super.subBuildingClassId,
    super.subBuildingClassName,
    super.parcels,
    super.municipalityId,
    super.municipalityName,
    super.subMunicipalityId,
    super.subMunicipalityName,
    super.districtId,
    super.districtName,
    super.mapNumber,
  });

  SurveyReportDataModel.fromJson(dynamic json) {
    licenseId = json['licenseId'];
    oldLicenseId = json['oldLicenseId'];
    licenseIssueDate = json['licenseIssueDate'];
    licenseIssueDateDesc = json['licenseIssueDateDesc'];
    purposeId = json['purposeId'];
    purposeName = json['purposeName'];
    mainBuildingClassId = json['mainBuildingClassId'];
    mainBuildingClassName = json['mainBuildingClassName'];
    subBuildingClassId = json['subBuildingClassId'];
    subBuildingClassName = json['subBuildingClassName'];
    if (json['parcels'] != null) {
      parcels = [];
      json['parcels'].forEach((v) {
        parcels?.add(ParcelDataModel.fromJson(v));
      });
    }
    municipalityId = json['municipalityId'];
    municipalityName = json['municipalityName'];
    subMunicipalityId = json['subMunicipalityId'];
    subMunicipalityName = json['subMunicipalityName'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    mapNumber = json['mapNumber'];
  }
}
