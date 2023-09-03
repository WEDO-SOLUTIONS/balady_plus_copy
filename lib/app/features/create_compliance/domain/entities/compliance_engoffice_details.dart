import 'package:equatable/equatable.dart';

class ComplianceEngOfficeDetails extends Equatable {
  final dynamic profileCompleted;
  final int? classificationStatus;
  final String? engOfficeNo;
  final String? engOfficeName;
  final String? engOwnerId;
  final String? engMobile;
  final String? engEmail;
  final String? classificationGrade;
  final String? certificateExpiryDate;
  final dynamic customType;
  final int? cityCode;
  final String? cityName;
  final dynamic engOfficeCr;
  final dynamic suspensionReason;
  final dynamic suspendingMunicipalityId;
  final dynamic suspendingMunicipalityName;

  ComplianceEngOfficeDetails({
    this.profileCompleted,
    this.classificationStatus,
    this.engOfficeNo,
    this.engOfficeName,
    this.engOwnerId,
    this.engMobile,
    this.engEmail,
    this.classificationGrade,
    this.certificateExpiryDate,
    this.customType,
    this.cityCode,
    this.cityName,
    this.engOfficeCr,
    this.suspensionReason,
    this.suspendingMunicipalityId,
    this.suspendingMunicipalityName,
  });

  factory ComplianceEngOfficeDetails.fromJson(Map<String, dynamic> json) =>
      ComplianceEngOfficeDetails(
        //  profileCompleted: json["profileCompleted"],
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

  @override
  List<Object?> get props => [engOfficeNo, engOfficeName];
}
