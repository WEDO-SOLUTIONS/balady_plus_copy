// To parse this JSON data, do
//
//     final crInformationResponse = crInformationResponseFromJson(jsonString);

import 'dart:convert';

CrInformationResponse crInformationResponseFromJson(String str) =>
    CrInformationResponse.fromJson(json.decode(str));

String crInformationResponseToJson(CrInformationResponse data) =>
    json.encode(data.toJson());

class CrInformationResponse {
  CrInformationResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory CrInformationResponse.fromJson(Map<String, dynamic> json) =>
      CrInformationResponse(
        statusDetails: json["statusDetails"] == null
            ? null
            : List<StatusDetail>.from(
                json["statusDetails"].map((x) => StatusDetail.fromJson(x))),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDetails": statusDetails == null
            ? null
            : List<dynamic>.from(statusDetails!.map((x) => x.toJson())),
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.responseCode,
    this.responseMessage,
    this.result,
  });

  String? responseCode;
  String? responseMessage;
  Result? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": result == null ? null : result!.toJson(),
      };
}

class Result {
  Result({
    this.crNumber,
    this.crType,
    this.crInfo,
    this.crOwners,
  });

  String? crNumber;
  int? crType;
  CrInfo? crInfo;
  List<CrOwner>? crOwners;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        crNumber: json["crNumber"],
        crType: json["crType"],
        crInfo: json["crInfo"] == null ? null : CrInfo.fromJson(json["crInfo"]),
        crOwners: json["crOwners"] == null
            ? null
            : List<CrOwner>.from(
                json["crOwners"].map((x) => CrOwner.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "crNumber": crNumber,
        "crType": crType,
        "crInfo": crInfo == null ? null : crInfo!.toJson(),
        "crOwners": crOwners == null
            ? null
            : List<dynamic>.from(crOwners!.map((x) => x.toJson())),
      };
}

class CrInfo {
  CrInfo({
    this.address,
    this.capital,
    this.cityAr,
    this.cityEn,
    this.issueDateHijri,
    this.expiryDateHijri,
    this.faxNo,
    this.legalTypeAr,
    this.legalTypeEn,
    this.nameAr,
    this.phoneNo,
    this.status,
    this.type,
    this.mainCrNumber,
    this.nationalNumber,
    this.entityType,
  });
  String? address;
  int? capital;
  String? cityAr;
  String? cityEn;
  String? issueDateHijri;
  String? expiryDateHijri;
  String? faxNo;
  String? legalTypeAr;
  String? legalTypeEn;
  String? nameAr;
  String? phoneNo;
  Status? status;
  String? type;
  String? mainCrNumber;
  String? nationalNumber;
  int? entityType;

  factory CrInfo.fromJson(Map<String, dynamic> json) => CrInfo(
        address: json["address"],
        capital: json["capital"],
        cityAr: json["cityAR"],
        cityEn: json["cityEN"],
        issueDateHijri: json["issueDateHijri"],
        expiryDateHijri: json["expiryDateHijri"],
        faxNo: json["faxNo"],
        legalTypeAr: json["legalTypeAR"],
        legalTypeEn: json["legalTypeEN"],
        nameAr: json["nameAR"],
        phoneNo: json["phoneNo"],
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        type: json["type"],
        mainCrNumber: json["mainCRNumber"],
        nationalNumber: json["nationalNumber"],
        entityType: json["entityType"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "capital": capital,
        "cityAR": cityAr,
        "cityEN": cityEn,
        "issueDateHijri": issueDateHijri,
        "expiryDateHijri": expiryDateHijri,
        "faxNo": faxNo,
        "legalTypeAR": legalTypeAr,
        "legalTypeEN": legalTypeEn,
        "nameAR": nameAr,
        "phoneNo": phoneNo,
        "status": status == null ? null : status!.toJson(),
        "type": type,
        "mainCRNumber": mainCrNumber,
        "nationalNumber": nationalNumber,
        "entityType": entityType,
      };
}

class Status {
  Status({
    this.crstatusDate,
    this.crstatusReason,
    this.status,
  });

  dynamic crstatusDate;
  dynamic crstatusReason;
  String? status;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        crstatusDate: json["crstatusDate"],
        crstatusReason: json["crstatusReason"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "crstatusDate": crstatusDate,
        "crstatusReason": crstatusReason,
        "status": status,
      };
}

class CrOwner {
  CrOwner({
    this.ownerId,
    this.ownerName,
    this.ownerNationalityAr,
    this.ownerNationalityEn,
    this.relationType,
    this.ownerIdFlat,
    this.relationTypeId,
  });

  OwnerId? ownerId;
  String? ownerName;
  String? ownerNationalityAr;
  String? ownerNationalityEn;
  String? relationType;
  String? ownerIdFlat;
  String? relationTypeId;

  factory CrOwner.fromJson(Map<String, dynamic> json) => CrOwner(
        ownerId:
            json["ownerID"] == null ? null : OwnerId.fromJson(json["ownerID"]),
        ownerName: json["ownerName"],
        ownerNationalityAr: json["ownerNationalityAR"],
        ownerNationalityEn: json["ownerNationalityEN"],
        relationType: json["relationType"],
        ownerIdFlat: json["ownerIdFlat"],
        relationTypeId: json["relationTypeID"],
      );

  Map<String, dynamic> toJson() => {
        "ownerID": ownerId == null ? null : ownerId!.toJson(),
        "ownerName": ownerName,
        "ownerNationalityAR": ownerNationalityAr,
        "ownerNationalityEN": ownerNationalityEn,
        "relationType": relationType,
        "ownerIdFlat": ownerIdFlat,
        "relationTypeID": relationTypeId,
      };
}

class OwnerId {
  OwnerId({
    this.borderNumber,
    this.code700,
    this.crnumber,
    this.passportIdentifier,
    this.personIdentifier,
  });

  String? borderNumber;
  String? code700;
  String? crnumber;
  dynamic passportIdentifier;
  PersonIdentifier? personIdentifier;

  factory OwnerId.fromJson(Map<String, dynamic> json) => OwnerId(
        borderNumber: json["borderNumber"],
        code700: json["code700"],
        crnumber: json["crnumber"],
        passportIdentifier: json["passportIdentifier"],
        personIdentifier: json["personIdentifier"] == null
            ? null
            : PersonIdentifier.fromJson(json["personIdentifier"]),
      );

  Map<String, dynamic> toJson() => {
        "borderNumber": borderNumber,
        "code700": code700,
        "crnumber": crnumber,
        "passportIdentifier": passportIdentifier,
        "personIdentifier":
            personIdentifier == null ? null : personIdentifier!.toJson(),
      };
}

class PersonIdentifier {
  PersonIdentifier({
    this.iqamaNumber,
    this.nationalId,
  });

  String? iqamaNumber;
  String? nationalId;

  factory PersonIdentifier.fromJson(Map<String, dynamic> json) =>
      PersonIdentifier(
        iqamaNumber: json["iqamaNumber"],
        nationalId: json["nationalID"],
      );

  Map<String, dynamic> toJson() => {
        "iqamaNumber": iqamaNumber,
        "nationalID": nationalId,
      };
}

class StatusDetail {
  StatusDetail({
    this.code,
    this.message,
  });

  int? code;
  String? message;

  factory StatusDetail.fromJson(Map<String, dynamic> json) => StatusDetail(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
