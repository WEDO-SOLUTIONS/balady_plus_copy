import '../../domain/entity/survey_inquery_data_entity.dart';

class SurveyDataModel extends SurveyInqueryData {
  SurveyDataModel(
      {super.licenseId,
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
      super.source,
      super.mapNumber,
      super.x,
      super.y});

  SurveyDataModel.fromJson(Map<String, dynamic> json) {
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
    source = json['source'];
    mapNumber = json['mapNumber'];
    x = json['x'];
    y = json['y'];
  }
}

class ParcelDataModel extends Parcel {
  ParcelDataModel({
    super.id,
    super.area,
    super.areaAccordingToScheme,
    super.landNo,
  });

  ParcelDataModel.fromJson(dynamic json) {
    id = json['id'];
    area = json['area']?.toDouble();
    areaAccordingToScheme = json['areaAccordingToScheme']?.toDouble();
    landNo = json['landNo'];
  }
}
