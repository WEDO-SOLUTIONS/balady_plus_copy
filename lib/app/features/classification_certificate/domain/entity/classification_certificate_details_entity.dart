
abstract class ClassificationCertificateDetailsEentity {
  final String ccPhoneNumber;
  final String limitSupervisionMax;
  final String attachLink;
  final String buildingHousingUnitsMin;
  final String facilityName;
  final String designContractInfoMin;
  final String turnkeyMax;
  final String limitSupervisionMin;
  final String classificationGrade;
  final String buildingHousingUnitsMax;
  final String status;
  final String turnkeyMin;
  final String cRorLicNumber;
  final String certificateStartDate;
  final String certificateExpiryDate;
  final String city;
  final String surveyingServicesMin;
  final String classificationType;
  final String emailAddress;
  final String serialNumber;
  final String designContractInfoMax;
  final String surveyingServicesMax;

  ClassificationCertificateDetailsEentity({
    required this.ccPhoneNumber,
    required this.limitSupervisionMax,
    required this.attachLink,
    required this.buildingHousingUnitsMin,
    required this.facilityName,
    required this.designContractInfoMin,
    required this.turnkeyMax,
    required this.limitSupervisionMin,
    required this.classificationGrade,
    required this.buildingHousingUnitsMax,
    required this.status,
    required this.turnkeyMin,
    required this.cRorLicNumber,
    required this.certificateStartDate,
    required this.city,
    required this.surveyingServicesMin,
    required this.classificationType,
    required this.emailAddress,
    required this.certificateExpiryDate,
    required this.serialNumber,
    required this.designContractInfoMax,
    required this.surveyingServicesMax,
  });

  ClassificationCertificateDetailsEentity copyWith({
    String? ccPhoneNumber,
    String? limitSupervisionMax,
    String? attachLink,
    String? buildingHousingUnitsMin,
    String? facilityName,
    String? designContractInfoMin,
    String? turnkeyMax,
    String? limitSupervisionMin,
    String? classificationGrade,
    String? buildingHousingUnitsMax,
    String? status,
    String? turnkeyMin,
    String? cRorLicNumber,
    String? certificateStartDate,
    String? city,
    String? surveyingServicesMin,
    String? classificationType,
    String? emailAddress,
    String? certificateExpiryDate,
    String? serialNumber,
    String? designContractInfoMax,
    String? surveyingServicesMax,
  });


  Map<String, dynamic> toJson();
}
