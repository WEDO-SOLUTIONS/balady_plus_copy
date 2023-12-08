import '../../domain/entities/compliance_engoffice_details.dart';

class ComplianceEngOfficeDetailsModel extends ComplianceEngOfficeDetails {
  ComplianceEngOfficeDetailsModel({
    super.profileCompleted,
    super.classificationStatus,
    super.engOfficeNo,
    super.engOfficeName,
    super.engOwnerId,
    super.engMobile,
    super.engEmail,
    super.classificationGrade,
    super.certificateExpiryDate,
    super.customType,
    super.cityCode,
    super.cityName,
    super.engOfficeCr,
    super.suspensionReason,
    super.suspendingMunicipalityId,
    super.suspendingMunicipalityName,
  });

  factory ComplianceEngOfficeDetailsModel.fromJson(Map<String, dynamic> json) =>
      ComplianceEngOfficeDetailsModel(
        profileCompleted: json["profileCompleted"],
        classificationStatus: json["ClassificationStatus"],
        engOfficeNo: json["EngOfficeNO"],
        engOfficeName: json["EngOfficeName"],
        engOwnerId: json["EngOwnerId"],
        engMobile: json["EngMobile"],
        engEmail: json["EngEmail"],
        classificationGrade: json["ClassificationGrade"],
        certificateExpiryDate: json["CertificateExpiryDate"],
        customType: json["CustomType"],
        cityCode: json["CityCode"],
        cityName: json["CityName"],
        engOfficeCr: json["EngOfficeCR"],
        suspensionReason: json["SuspensionReason"],
        suspendingMunicipalityId: json["SuspendingMunicipalityId"],
        suspendingMunicipalityName: json["SuspendingMunicipalityName"],
      );
}
