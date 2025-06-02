import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';

class RegisterObserverRequest {
  RegisterObserverRequest({
    this.birthDate,
    this.firstName,
    this.fatherName,
    this.grandFatherName,
    this.familyName,
    this.gender,
    // this.externalEntityID,
    this.municipality,
    this.city,
    this.district,
    this.iban,
    this.bankInfo,
    // this.bankName,
    // this.bankID,
    this.email,
    this.mobileNumber,
    this.academicQualification,
    this.maritalStatus,
    this.surveyQuestion1,
    this.surveyQuestion2,
    this.surveyQuestion3,
    this.surveyQuestion4,
    this.qualificationStatus,
    this.freelanceCertificateNumber,
    this.freelanceCertificateExpiryDate,
    this.districtList,
    this.pledgeQuestion = false,
  });

  // RegisterObserverRequest.fromJson(dynamic json) {
  //   iDNumber = json['IDNumber'];
  //   birthDate = json['BirthDate'];
  //   firstName = json['FirstName'];
  //   fatherName = json['FatherName'];
  //   grandFatherName = json['GrandFatherName'];
  //   familyName = json['FamilyName'];
  //   gender = json['Gender'];
  //   externalEntityID = json['ExternalEntityID'];
  //   municipalityID = json['MunicipalityID'];
  //   cityCode = json['CityCode'];
  //   cityCode = json['CityCode'];
  //   iban = json['IBAN'];
  //   bankName = json['BankName'];
  //   bankID = json['BankID'];
  //   email = json['Email'];
  //   mobileNumber = json['MobileNumber'];
  //   academicQualification = json['AcademicQualification'];
  //   maritalStatus = json['MaritalStatus'];
  //   surveyQuestion1 = json['SurveyQuestion1'];
  //   surveyQuestion2 = json['SurveyQuestion2'];
  //   surveyQuestion3 = json['SurveyQuestion3'];
  //   surveyQuestion4 = json['SurveyQuestion4'];
  //   qualificationStatus = json['QualificationStatus'];
  //   freelanceCertificateNumber = json['FreelanceCertificateNumber'];
  //   freelanceCertificateExpiryDate = json['FreelanceCertificateExpiryDate'];
  //   if (json['DistrictList'] != null) {
  //     districtList = [];
  //     json['DistrictList'].forEach((v) {
  //       districtList?.add(DistrictList.fromJson(v));
  //     });
  //   }
  // }

  //// User Data Applicant
  String? birthDate;
  String? firstName;
  String? fatherName;
  String? grandFatherName;
  String? familyName;
  String? gender;
  // String? externalEntityID;

  //// Location Info
  LookUpItem? municipality;
  LookUpItem? city;
  LookUpItem? district;
  List<DistrictList>? districtList;

  //// Personal Info
  LookUpItem? academicQualification;
  LookUpItem? maritalStatus;

  //// Bank Info
  LookUpItem? bankInfo;
  String? iban;

  // String? bankName;
  // String? bankID;
  String? email;
  String? mobileNumber;
  bool? surveyQuestion1;
  bool? surveyQuestion2;
  bool? surveyQuestion3;
  bool? surveyQuestion4;
  String? qualificationStatus;
  String? freelanceCertificateNumber;
  String? freelanceCertificateExpiryDate;

  ////////////
  bool pledgeQuestion;

  RegisterObserverRequest copyWith({
    String? birthDate,
    String? firstName,
    String? fatherName,
    String? grandFatherName,
    String? familyName,
    String? gender,
    // String? externalEntityID,
    LookUpItem? municipalityID,
    LookUpItem? city,
    LookUpItem? district,
    String? iban,
    String? bankName,
    String? bankID,
    String? email,
    String? mobileNumber,
    LookUpItem? academicQualification,
    LookUpItem? maritalStatus,
    bool? surveyQuestion1,
    bool? surveyQuestion2,
    bool? surveyQuestion3,
    bool? surveyQuestion4,
    String? qualificationStatus,
    String? freelanceCertificateNumber,
    String? freelanceCertificateExpiryDate,
    List<DistrictList>? districtList,
    LookUpItem? bankInfo,
    bool? pledgeQuestion,
  }) =>
      RegisterObserverRequest(
        birthDate: birthDate ?? this.birthDate,
        firstName: firstName ?? this.firstName,
        fatherName: fatherName ?? this.fatherName,
        grandFatherName: grandFatherName ?? this.grandFatherName,
        familyName: familyName ?? this.familyName,
        gender: gender ?? this.gender,
        // externalEntityID: externalEntityID ?? this.externalEntityID,
        municipality: municipalityID ?? this.municipality,
        city: city ?? this.city,
        district: district ?? this.district,
        iban: iban ?? this.iban,
        bankInfo: bankInfo ?? this.bankInfo,
        // bankName: bankName ?? this.bankName,
        // bankID: bankID ?? this.bankID,
        email: email ?? this.email,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        academicQualification:
            academicQualification ?? this.academicQualification,
        maritalStatus: maritalStatus ?? this.maritalStatus,
        surveyQuestion1: surveyQuestion1 ?? this.surveyQuestion1,
        surveyQuestion2: surveyQuestion2 ?? this.surveyQuestion2,
        surveyQuestion3: surveyQuestion3 ?? this.surveyQuestion3,
        surveyQuestion4: surveyQuestion4 ?? this.surveyQuestion4,
        qualificationStatus: qualificationStatus ?? this.qualificationStatus,
        freelanceCertificateNumber:
            freelanceCertificateNumber ?? this.freelanceCertificateNumber,
        freelanceCertificateExpiryDate: freelanceCertificateExpiryDate ??
            this.freelanceCertificateExpiryDate,
        districtList: districtList ?? this.districtList,
        pledgeQuestion: pledgeQuestion ?? this.pledgeQuestion,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MunicipalityID'] = municipality?.strId;
    map['CityCode'] = city?.strId;
    map['IBAN'] = iban;
    map['BankName'] = bankInfo?.name;
    map['BankID'] = bankInfo?.id;
    map['Email'] = email;
    map['MobileNumber'] = mobileNumber;
    map['AcademicQualification'] = academicQualification?.name;
    map['MaritalStatus'] = maritalStatus?.name;
    map['SurveyQuestion1'] = surveyQuestion1;
    map['SurveyQuestion2'] = surveyQuestion2;
    map['SurveyQuestion3'] = surveyQuestion3;
    map['SurveyQuestion4'] = surveyQuestion4;
    if (district != null) {
      map['DistrictList'] = [
        {"DistrictID": district?.strId, "DistrictName": district?.name}
      ];
    }


    //////////// AGC-0032
    //////////// AGC-3235
    map['ExternalEntityID'] = "AGC-0032";

    return map;
  }
}

class DistrictList {
  DistrictList({
    this.districtID,
    this.districtName,
  });

  DistrictList.fromJson(dynamic json) {
    districtID = json['DistrictID'];
    districtName = json['DistrictName'];
  }

  String? districtID;
  String? districtName;

  DistrictList copyWith({
    String? districtID,
    String? districtName,
  }) =>
      DistrictList(
        districtID: districtID ?? this.districtID,
        districtName: districtName ?? this.districtName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistrictID'] = districtID;
    map['DistrictName'] = districtName;
    return map;
  }
}
