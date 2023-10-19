// To parse this JSON data, do
//
//     final verifyOtpCertificate = verifyOtpCertificateFromJson(jsonString);

import 'dart:convert';

UpdatePhotoResponse verifyOtpCertificateFromJson(String str) =>
    UpdatePhotoResponse.fromJson(json.decode(str));

String verifyOtpCertificateToJson(UpdatePhotoResponse data) =>
    json.encode(data.toJson());

class UpdatePhotoResponse {
  final StatusDetails? statusDetails;
  final Data? data;

  UpdatePhotoResponse({
    this.statusDetails,
    this.data,
  });

  factory UpdatePhotoResponse.fromJson(Map<String, dynamic> json) =>
      UpdatePhotoResponse(
        statusDetails: json["statusDetails"] == null
            ? null
            : StatusDetails.fromJson(json["statusDetails"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDetails": statusDetails?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  final String? responseCode;
  final String? responseMessage;
  final String? responseId;
  final String? result;

  Data({
    this.responseCode,
    this.responseMessage,
    this.responseId,
    this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        responseId: json["responseId"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "responseId": responseId,
        "result": result,
      };
}

class StatusDetails {
  final int? code;
  final String? message;

  StatusDetails({
    this.code,
    this.message,
  });

  factory StatusDetails.fromJson(Map<String, dynamic> json) => StatusDetails(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
