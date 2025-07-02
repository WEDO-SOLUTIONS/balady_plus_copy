// To parse this JSON data, do
//
//     final locationInfoResponse = locationInfoResponseFromJson(jsonString);

import 'dart:convert';

LocationInfoResponse locationInfoResponseFromJson(String str) =>
    LocationInfoResponse.fromJson(json.decode(str));

String locationInfoResponseToJson(LocationInfoResponse data) =>
    json.encode(data.toJson());

class LocationInfoResponse {
  LocationInfoResponse({
    this.statusDetails,
    this.data,
  });

  StatusDetail? statusDetails;
  LocationData? data;

  factory LocationInfoResponse.fromJson(Map<String, dynamic> json) =>
      LocationInfoResponse(
        statusDetails: StatusDetail.fromJson(json["statusDetails"]),
        data: json["data"] != null ? LocationData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "statusDetails": statusDetails?.toJson(),
        "data": data?.toJson(),
      };
}

class LocationData {
  LocationData({
    this.responseCode,
    this.responseMessage,
    this.responseId,
    this.result,
  });

  String? responseCode;
  String? responseMessage;
  String? responseId;
  LocationResult? result;

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        responseId: json["responseId"],
        result: json["result"] != null
            ? LocationResult.fromJson(json["result"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "responseId": responseId,
        if (result != null) "result": result?.toJson(),
      };
}

class LocationResult {
  LocationResult({
    this.streetCode,
    this.streetName,
    this.districtCode,
    this.districtName,
    this.municipalityId,
    this.municipalityName,
    this.subMunicipalityId,
    this.subMunicipalityName,
    this.cityCode,
    this.cityName,
    this.x,
    this.y,
    this.validToApply,
    this.message,
  });

  dynamic streetCode;
  dynamic streetName;
  int? districtCode;
  String? districtName;
  String? municipalityId;
  String? municipalityName;
  String? subMunicipalityId;
  String? subMunicipalityName;
  int? cityCode;
  String? cityName;
  String? x;
  String? y;
  bool? validToApply;
  dynamic message;

  factory LocationResult.fromJson(Map<String, dynamic> json) => LocationResult(
        streetCode: json["streetCode"],
        streetName: json["streetName"],
        districtCode: json["districtCode"],
        districtName: json["districtName"],
        municipalityId: json["municipalityId"],
        municipalityName: json["municipalityName"],
        subMunicipalityId: json["subMunicipalityId"],
        subMunicipalityName: json["subMunicipalityName"],
        cityCode: json["cityCode"],
        cityName: json["cityName"]?.toString().trim(),
        x: json["x"],
        y: json["y"],
        validToApply: json["validToApply"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "streetCode": streetCode,
        "streetName": streetName,
        "districtCode": districtCode,
        "districtName": districtName,
        "municipalityId": municipalityId,
        "municipalityName": municipalityName,
        "subMunicipalityId": subMunicipalityId,
        "subMunicipalityName": subMunicipalityName,
        "cityCode": cityCode,
        "cityName": cityName,
        "x": x,
        "y": y,
        "validToApply": validToApply,
        "message": message,
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
