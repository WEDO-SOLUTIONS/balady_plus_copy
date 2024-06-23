// To parse this JSON data, do
//
//     final cancelAppointmentModel = cancelAppointmentModelFromJson(jsonString);

import 'dart:convert';

CancelAppointmentResponse cancelAppointmentModelFromJson(String str) =>
    CancelAppointmentResponse.fromJson(json.decode(str));

String CancelAppointmentResponseToJson(CancelAppointmentResponse data) =>
    json.encode(data.toJson());

class CancelAppointmentResponse {
  CancelAppointmentResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory CancelAppointmentResponse.fromJson(Map<String, dynamic> json) =>
      CancelAppointmentResponse(
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
  bool? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode:
            json["responseCode"] == null ? null : json["responseCode"],
        responseMessage:
            json["responseMessage"] == null ? null : json["responseMessage"],
        result: json["result"] == null ? null : json["result"],
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode == null ? null : responseCode,
        "responseMessage": responseMessage == null ? null : responseMessage,
        "result": result == null ? null : result,
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
