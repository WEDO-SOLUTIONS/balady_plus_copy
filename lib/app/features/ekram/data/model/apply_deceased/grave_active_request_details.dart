import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class GraveActiveRequestDetails {
  final int? requestId;
  final String? requestKey;
  final String? requestDate;
  final String? submitDate;
  final dynamic approvedDate;
  final String? lastUpdateDate;
  final int? requestTypeId;
  final String? requestTypeName;
  final int? requestStatusId;
  final String? requestStatusName;
  final int? entryMode;
  final Municipality? municipality;
  final Info? submitterInfo;
  final Info? deceasedInfo;
  final ApplicantInfo? applicantInfo;
  final BurialInfo? burialInfo;
  final dynamic notes;
  final dynamic transportRequestId;
  final dynamic employeeDecisionId;
  final dynamic employeeDecisionName;
  final List<dynamic>? attachments;
  final bool? actionable;

  GraveActiveRequestDetails({
    this.requestId,
    this.requestKey,
    this.requestDate,
    this.submitDate,
    this.approvedDate,
    this.lastUpdateDate,
    this.requestTypeId,
    this.requestTypeName,
    this.requestStatusId,
    this.requestStatusName,
    this.entryMode,
    this.municipality,
    this.submitterInfo,
    this.deceasedInfo,
    this.applicantInfo,
    this.burialInfo,
    this.notes,
    this.transportRequestId,
    this.employeeDecisionId,
    this.employeeDecisionName,
    this.attachments,
    this.actionable,
  });

  factory GraveActiveRequestDetails.fromJson(Map<String, dynamic> json) =>
      GraveActiveRequestDetails(
        requestId: json["requestId"],
        requestKey: json["requestKey"],
        requestDate: json["requestDate"],
        submitDate: json["submitDate"],
        approvedDate: json["approvedDate"],
        lastUpdateDate: json["lastUpdateDate"],
        requestTypeId: json["requestTypeId"],
        requestTypeName: json["requestTypeName"],
        requestStatusId: json["requestStatusId"],
        requestStatusName: json["requestStatusName"],
        entryMode: json["entryMode"],
        municipality: json["municipality"] == null
            ? null
            : Municipality.fromJson(json["municipality"]),
        submitterInfo: json["submitterInfo"] == null
            ? null
            : Info.fromJson(json["submitterInfo"]),
        deceasedInfo: json["deceasedInfo"] == null
            ? null
            : Info.fromJson(json["deceasedInfo"]),
        applicantInfo: json["applicantInfo"] == null
            ? null
            : ApplicantInfo.fromJson(json["applicantInfo"]),
        burialInfo: json["burialInfo"] == null
            ? null
            : BurialInfo.fromJson(json["burialInfo"]),
        notes: json["notes"],
        transportRequestId: json["transportRequestId"],
        employeeDecisionId: json["employeeDecisionId"],
        employeeDecisionName: json["employeeDecisionName"],
        attachments: json["attachments"] == null
            ? []
            : List<dynamic>.from(json["attachments"]!.map((x) => x)),
        actionable: json["actionable"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "requestKey": requestKey,
        "requestDate": requestDate,
        "submitDate": submitDate,
        "approvedDate": approvedDate,
        "lastUpdateDate": lastUpdateDate,
        "requestTypeId": requestTypeId,
        "requestTypeName": requestTypeName,
        "requestStatusId": requestStatusId,
        "requestStatusName": requestStatusName,
        "entryMode": entryMode,
        "municipality": municipality?.toJson(),
        "submitterInfo": submitterInfo?.toJson(),
        "deceasedInfo": deceasedInfo?.toJson(),
        "applicantInfo": applicantInfo?.toJson(),
        "burialInfo": burialInfo?.toJson(),
        "notes": notes,
        "transportRequestId": transportRequestId,
        "employeeDecisionId": employeeDecisionId,
        "employeeDecisionName": employeeDecisionName,
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x)),
        "actionable": actionable,
      };
}

class ApplicantInfo {
  final dynamic relationshipId;
  final dynamic relationshipName;
  final dynamic relationshipOthers;
  final dynamic requestSourceId;
  final dynamic requestSourceName;
  final String? applicantName;
  final String? mobileNumber;

  ApplicantInfo({
    this.relationshipId,
    this.relationshipName,
    this.relationshipOthers,
    this.requestSourceId,
    this.requestSourceName,
    this.applicantName,
    this.mobileNumber,
  });

  factory ApplicantInfo.fromJson(Map<String, dynamic> json) => ApplicantInfo(
        relationshipId: json["relationshipId"],
        relationshipName: json["relationshipName"],
        relationshipOthers: json["relationshipOthers"],
        requestSourceId: json["requestSourceId"],
        requestSourceName: json["requestSourceName"],
        applicantName: json["applicantName"],
        mobileNumber: json["mobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "relationshipId": relationshipId,
        "relationshipName": relationshipName,
        "relationshipOthers": relationshipOthers,
        "requestSourceId": requestSourceId,
        "requestSourceName": requestSourceName,
        "applicantName": applicantName,
        "mobileNumber": mobileNumber,
      };
}

class BurialInfo {
  final int? deathCountryId;
  final int? deathCityId;
  final dynamic deathCityOther;
  final String? burialDate;
  final int? prayId;
  final dynamic cemeteryId;
  final bool? fetus;
  final int? graveTypeId;
  final bool? isPandemicDeath;
  final dynamic prayOther;
  final String? deathCountryName;
  final String? deathCityName;
  final dynamic burialCityName;
  final String? burialDateHijri;
  final String? prayName;
  final CemeteryInfo? cemeteryInfo;
  final String? graveTypeName;
  final int? graveSizeId;
  final String? graveSizeName;
  final dynamic burialCityId;
  final dynamic baqieBurialPermitStatusId;
  final dynamic baqieBurialPermitStatus;
  final dynamic baqieBurialPermitApprovalDate;

  BurialInfo({
    this.deathCountryId,
    this.deathCityId,
    this.deathCityOther,
    this.burialDate,
    this.prayId,
    this.cemeteryId,
    this.fetus,
    this.graveTypeId,
    this.isPandemicDeath,
    this.prayOther,
    this.deathCountryName,
    this.deathCityName,
    this.burialCityName,
    this.burialDateHijri,
    this.prayName,
    this.cemeteryInfo,
    this.graveTypeName,
    this.graveSizeId,
    this.graveSizeName,
    this.burialCityId,
    this.baqieBurialPermitStatusId,
    this.baqieBurialPermitStatus,
    this.baqieBurialPermitApprovalDate,
  });

  factory BurialInfo.fromJson(Map<String, dynamic> json) => BurialInfo(
        deathCountryId: json["deathCountryId"],
        deathCityId: json["deathCityId"],
        deathCityOther: json["deathCityOther"],
        burialDate: json["burialDate"],
        prayId: json["prayId"],
        cemeteryId: json["cemeteryId"],
        fetus: json["fetus"],
        graveTypeId: json["graveTypeId"],
        isPandemicDeath: json["isPandemicDeath"],
        prayOther: json["prayOther"],
        deathCountryName: json["deathCountryName"],
        deathCityName: json["deathCityName"],
        burialCityName: json["burialCityName"],
        burialDateHijri: json["burialDateHijri"],
        prayName: json["prayName"],
        cemeteryInfo: json["cemeteryInfo"] == null
            ? null
            : CemeteryInfo.fromJson(json["cemeteryInfo"]),
        graveTypeName: json["graveTypeName"],
        graveSizeId: json["graveSizeId"],
        graveSizeName: json["graveSizeName"],
        burialCityId: json["burialCityId"],
        baqieBurialPermitStatusId: json["baqieBurialPermitStatusId"],
        baqieBurialPermitStatus: json["baqieBurialPermitStatus"],
        baqieBurialPermitApprovalDate: json["baqieBurialPermitApprovalDate"],
      );

  Map<String, dynamic> toJson() => {
        "deathCountryId": deathCountryId,
        "deathCityId": deathCityId,
        "deathCityOther": deathCityOther,
        "burialDate": burialDate,
        "prayId": prayId,
        "cemeteryId": cemeteryId,
        "fetus": fetus,
        "graveTypeId": graveTypeId,
        "isPandemicDeath": isPandemicDeath,
        "prayOther": prayOther,
        "deathCountryName": deathCountryName,
        "deathCityName": deathCityName,
        "burialCityName": burialCityName,
        "burialDateHijri": burialDateHijri,
        "prayName": prayName,
        "cemeteryInfo": cemeteryInfo?.toJson(),
        "graveTypeName": graveTypeName,
        "graveSizeId": graveSizeId,
        "graveSizeName": graveSizeName,
        "burialCityId": burialCityId,
        "baqieBurialPermitStatusId": baqieBurialPermitStatusId,
        "baqieBurialPermitStatus": baqieBurialPermitStatus,
        "baqieBurialPermitApprovalDate": baqieBurialPermitApprovalDate,
      };

  String? getHijriDate() {
    // Replace "/" with "-" to make it a valid format for DateTime.parse
    String dateString = burialDate?.replaceAll('/', '-') ?? "";

    // Parse the string into a DateTime object
    DateTime? gorgianDate = DateTime.tryParse(dateString);

    print("gorgianDate $gorgianDate");
    if (gorgianDate != null) {
      if (isToday(gorgianDate) || isTomorrow(gorgianDate)) {
        return burialDate;
      }
    }

    return null;
  }

  bool isToday(DateTime date) {
    DateTime today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  bool isTomorrow(DateTime date) {
    DateTime tomorrow = DateTime.now().add(Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }
}

class CemeteryInfo {
  final int? cemeteryId;
  final String? cemeteryName;
  final dynamic streetId;
  final dynamic streetName;
  final int? districtId;
  final String? districtName;
  final String? longitude;
  final String? latitude;
  final Municipality? municipality;

  CemeteryInfo({
    this.cemeteryId,
    this.cemeteryName,
    this.streetId,
    this.streetName,
    this.districtId,
    this.districtName,
    this.longitude,
    this.latitude,
    this.municipality,
  });

  factory CemeteryInfo.fromJson(Map<String, dynamic> json) => CemeteryInfo(
        cemeteryId: json["cemeteryId"],
        cemeteryName: json["cemeteryName"],
        streetId: json["streetId"],
        streetName: json["streetName"],
        districtId: json["districtId"],
        districtName: json["districtName"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        municipality: json["municipality"] == null
            ? null
            : Municipality.fromJson(json["municipality"]),
      );

  Map<String, dynamic> toJson() => {
        "cemeteryId": cemeteryId,
        "cemeteryName": cemeteryName,
        "streetId": streetId,
        "streetName": streetName,
        "districtId": districtId,
        "districtName": districtName,
        "longitude": longitude,
        "latitude": latitude,
        "municipality": municipality?.toJson(),
      };
}

class Municipality {
  final String? subMunicipalityId;
  final int? baladiaId;
  final String? subMunicipalityName;
  final String? municipalityId;
  final int? amanaId;
  final String? municipalityName;
  final int? cityId;
  final String? cityName;

  Municipality({
    this.subMunicipalityId,
    this.baladiaId,
    this.subMunicipalityName,
    this.municipalityId,
    this.amanaId,
    this.municipalityName,
    this.cityId,
    this.cityName,
  });

  factory Municipality.fromJson(Map<String, dynamic> json) => Municipality(
        subMunicipalityId: json["subMunicipalityId"],
        baladiaId: json["baladiaId"],
        subMunicipalityName: json["subMunicipalityName"],
        municipalityId: json["municipalityId"],
        amanaId: json["amanaId"],
        municipalityName: json["municipalityName"],
        cityId: json["cityId"],
        cityName: json["cityName"],
      );

  Map<String, dynamic> toJson() => {
        "subMunicipalityId": subMunicipalityId,
        "baladiaId": baladiaId,
        "subMunicipalityName": subMunicipalityName,
        "municipalityId": municipalityId,
        "amanaId": amanaId,
        "municipalityName": municipalityName,
        "cityId": cityId,
        "cityName": cityName,
      };
}

class Info {
  final String? identityNumber;
  final int? identityType;
  final String? firstName;
  final String? secondName;
  final String? thirdName;
  final String? fourthName;
  final String? fullName;
  final String? birthDate;
  final int? nationalityId;
  final String? nationalityName;
  final bool? isMuslim;
  final String? mobileNumber;
  final String? gender;

  Info({
    this.identityNumber,
    this.identityType,
    this.firstName,
    this.secondName,
    this.thirdName,
    this.fourthName,
    this.fullName,
    this.birthDate,
    this.nationalityId,
    this.nationalityName,
    this.isMuslim,
    this.mobileNumber,
    this.gender,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        identityNumber: json["identityNumber"],
        identityType: json["identityType"],
        firstName: json["firstName"],
        secondName: json["secondName"],
        thirdName: json["thirdName"],
        fourthName: json["fourthName"],
        fullName: json["fullName"],
        birthDate: json["birthDate"],
        nationalityId: json["nationalityId"],
        nationalityName: json["nationalityName"],
        isMuslim: json["isMuslim"],
        mobileNumber: json["mobileNumber"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "identityNumber": identityNumber,
        "identityType": identityType,
        "firstName": firstName,
        "secondName": secondName,
        "thirdName": thirdName,
        "fourthName": fourthName,
        "fullName": fullName,
        "birthDate": birthDate,
        "nationalityId": nationalityId,
        "nationalityName": nationalityName,
        "isMuslim": isMuslim,
        "mobileNumber": mobileNumber,
        "gender": gender,
      };
}
