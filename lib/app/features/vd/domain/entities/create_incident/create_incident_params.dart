import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show AddetionalDetailsItem;

class CreateIncidentParams {
  // Unregistered User Info
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? referenceID;
  String? otpValue;

// Location Info
  String? municipalityID;
  String? subMunicipalityID;
  String? sub_SubMunicipalityID;
  String? latitude;
  String? longitude;
  String? address;
  String? streetName;
  String? districtName;

// IncidentInformation
  String? splClassificationID;
  String? issueDescription;
  String? continueIncidentCreation;
  List<AddetionalDetailsItem>? questionList;
  List<String>? attachments;
  String? crNumber;

  CreateIncidentParams(
      {this.address,
      this.attachments,
      this.districtName,
      this.firstName,
      this.issueDescription,
      this.lastName,
      this.latitude,
      this.longitude,
      this.mobileNumber,
      this.municipalityID,
      this.otpValue,
      this.continueIncidentCreation,
      this.questionList,
      this.referenceID,
      this.splClassificationID,
      this.streetName,
      this.subMunicipalityID,
      this.sub_SubMunicipalityID,
      this.crNumber});

  CreateIncidentParams copyWith(
      {String? firstName,
      String? lastName,
      String? mobileNumber,
      String? referenceID,
      String? otpValue,

// Location Info
      String? municipalityID,
      String? subMunicipalityID,
      String? sub_SubMunicipalityID,
      String? latitude,
      String? longitude,
      String? address,
      String? streetName,
      String? districtName,

// IncidentInformation
      String? splClassificationID,
      String? issueDescription,
      String? continueIncidentCreation,
      String? crNumber,
      List<AddetionalDetailsItem>? questionList,
      List<String>? attachments}) {
    return CreateIncidentParams(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        referenceID: referenceID ?? this.referenceID,
        otpValue: otpValue ?? this.otpValue,
        municipalityID: municipalityID ?? this.municipalityID,
        subMunicipalityID: subMunicipalityID ?? this.subMunicipalityID,
        sub_SubMunicipalityID:
            sub_SubMunicipalityID ?? this.sub_SubMunicipalityID,
        crNumber: crNumber ?? this.crNumber,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address,
        streetName: streetName ?? this.streetName,
        districtName: districtName ?? this.districtName,
        splClassificationID: splClassificationID ?? this.splClassificationID,
        issueDescription: issueDescription ?? this.issueDescription,
        continueIncidentCreation:
            continueIncidentCreation ?? this.continueIncidentCreation,
        questionList: questionList ?? this.questionList,
        attachments: attachments ?? this.attachments);
  }

  getQuestionsList() {
    if (questionList != null && questionList!.isNotEmpty) {
      var list = questionList!
          .map((e) => e.requestJson())
          .toList()
          .where((element) => element != null)
          .toList();
      return list;
    }
    return null;
  }

  Map<String, dynamic> toMap({bool isGuest = false}) {
    return {
      if (isGuest)
        "CustomerInformation": {
          "FirstName": firstName,
          "LastName": lastName,
          "MobileNumber": mobileNumber,
          "ReferenceID": referenceID,
          "OTPValue": otpValue,
        },
      "LocationInfo": {
        "MunicipalityID": municipalityID,
        "SubMunicipalityID": subMunicipalityID,
        "Sub_SubMunicipalityID": sub_SubMunicipalityID,
        "Longitude": longitude,
        "Latitude": latitude,
        "Address": address,
        "StreetName": streetName,
        "DistrictName": districtName,
      },
      "IncidentInformation": {
        "SplClassificationID": splClassificationID,
        "IssueDescription": issueDescription,
        if (getQuestionsList() != null) "QuestionList": getQuestionsList(),
        if (continueIncidentCreation != null)
          "ContinueIncidentCreation": continueIncidentCreation,
        if (crNumber != null) "CRNumber": crNumber
      },
      if (attachments != null && attachments!.isNotEmpty)
        "Attachments": attachments?.map((e) => {"AttachmentID": e}).toList()
    };
  }
}
