// To parse this JSON data, do
//
//     final cancelAppointmentModel = cancelAppointmentModelFromJson(jsonString);

import 'dart:convert';

ConfirmAppointmentResponse cancelAppointmentModelFromJson(String str) =>
    ConfirmAppointmentResponse.fromJson(json.decode(str));

String ConfirmAppointmentResponseToJson(ConfirmAppointmentResponse data) =>
    json.encode(data.toJson());

class ConfirmAppointmentResponse {
  ConfirmAppointmentResponse({
    this.statusDetails,
    this.data,
  });

    StatusDetail? statusDetails;
  Data? data;

  factory ConfirmAppointmentResponse.fromJson(Map<String, dynamic> json) =>
      ConfirmAppointmentResponse(
        statusDetails: json["statusDetails"] == null
            ? null
            : StatusDetail.fromJson(json["statusDetails"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDetails": statusDetails?.toJson(),
        "data": data?.toJson(),
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
        responseCode:
            json["responseCode"] == null ? null : json["responseCode"],
        responseMessage:
            json["responseMessage"] == null ? null : json["responseMessage"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode == null ? null : responseCode,
        "responseMessage": responseMessage == null ? null : responseMessage,
        "result": result == null ? null : result?.toJson(),
      };
}

class Result {
  String? uuid;
  Result({this.uuid});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        uuid: json["uuid"] == null ? null : json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid == null ? null : uuid,
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
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
      };
}
