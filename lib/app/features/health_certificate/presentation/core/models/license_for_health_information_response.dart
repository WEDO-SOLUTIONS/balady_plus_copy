// To parse this JSON data, do
//
//     final licenseForHealthInformationResponse = licenseForHealthInformationResponseFromJson(jsonString);

import 'dart:convert';

LicenseForHealthInformationResponse licenseForHealthInformationResponseFromJson(
        String str) =>
    LicenseForHealthInformationResponse.fromJson(json.decode(str));

String licenseForHealthInformationResponseToJson(
        LicenseForHealthInformationResponse data) =>
    json.encode(data.toJson());

class LicenseForHealthInformationResponse {
  LicenseForHealthInformationResponse({
    this.statusDetails,
    this.data,
  });

  StatusDetail? statusDetails;
  Data? data;

  factory LicenseForHealthInformationResponse.fromJson(
          Map<String, dynamic> json) =>
      LicenseForHealthInformationResponse(
        statusDetails: json["statusDetails"] == null
            ? null
            : StatusDetail.fromJson(json["statusDetails"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
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
    this.licenseNo,
    this.municipalityId,
    this.subMunicipalityId,
    this.municipalityName,
    this.subMunicipalityName,
    this.activityId,
    this.activityName,
    this.isicNumber,
    this.isicName,
    this.crNumber,
    this.entityName,
    this.crName,
    this.licenseStatusId,
    this.licenseStatusName,
    this.shopName,
    this.entityType,
    this.districtId,
    this.districtName,
    this.streetId,
    this.streetName,
    this.longitude,
    this.latitude,
    this.sadadEndDate,
    this.notes,
    this.licenseStartDate,
    this.licenseEndDate,
    this.valid,
  });

  int? licenseNo;
  String? municipalityId;
  String? subMunicipalityId;
  String? municipalityName;
  String? subMunicipalityName;
  int? activityId;
  String? activityName;
  String? isicNumber;
  String? isicName;
  String? crNumber;
  String? entityName;
  String? crName;
  int? licenseStatusId;
  String? licenseStatusName;
  String? shopName;
  String? entityType;
  int? districtId;
  String? districtName;
  dynamic streetId;
  dynamic streetName;
  dynamic longitude;
  dynamic latitude;
  String? sadadEndDate;
  dynamic notes;
  String? licenseStartDate;
  String? licenseEndDate;
  bool? valid;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        licenseNo: json["licenseNo"],
        municipalityId: json["municipalityId"],
        subMunicipalityId: json["subMunicipalityId"],
        municipalityName: json["municipalityName"],
        subMunicipalityName: json["subMunicipalityName"],
        activityId: json["activityId"],
        activityName: json["activityName"],
        isicNumber: json["isicNumber"],
        isicName: json["isicName"],
        crNumber: json["crNumber"],
        entityName: json["entityName"],
        crName: json["crName"],
        licenseStatusId: json["licenseStatusId"],
        licenseStatusName: json["licenseStatusName"],
        shopName: json["shopName"],
        entityType: json["entityType"],
        districtId: json["districtId"],
        districtName: json["districtName"],
        streetId: json["streetId"],
        streetName: json["streetName"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        sadadEndDate: json["sadadEndDate"],
        notes: json["notes"],
        licenseStartDate: json["licenseStartDate"],
        licenseEndDate: json["licenseEndDate"],
        valid: json["valid"],
      );

  Map<String, dynamic> toJson() => {
        "licenseNo": licenseNo,
        "municipalityId": municipalityId,
        "subMunicipalityId": subMunicipalityId,
        "municipalityName": municipalityName,
        "subMunicipalityName": subMunicipalityName,
        "activityId": activityId,
        "activityName": activityName,
        "isicNumber": isicNumber,
        "isicName": isicName,
        "crNumber": crNumber,
        "entityName": entityName,
        "crName": crName,
        "licenseStatusId": licenseStatusId,
        "licenseStatusName": licenseStatusName,
        "shopName": shopName,
        "entityType": entityType,
        "districtId": districtId,
        "districtName": districtName,
        "streetId": streetId,
        "streetName": streetName,
        "longitude": longitude,
        "latitude": latitude,
        "sadadEndDate": sadadEndDate,
        "notes": notes,
        "licenseStartDate": licenseStartDate,
        "licenseEndDate": licenseEndDate,
        "valid": valid,
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
