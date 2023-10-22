// To parse this JSON data, do
//
//     final verifyOtpCertificate = verifyOtpCertificateFromJson(jsonString);

import 'dart:convert';

VerifyOtpCertificate verifyOtpCertificateFromJson(String str) =>
    VerifyOtpCertificate.fromJson(json.decode(str));

String verifyOtpCertificateToJson(VerifyOtpCertificate data) =>
    json.encode(data.toJson());

class VerifyOtpCertificate {
  final StatusDetails? statusDetails;
  final Data? data;

  VerifyOtpCertificate({
    this.statusDetails,
    this.data,
  });

  factory VerifyOtpCertificate.fromJson(Map<String, dynamic> json) =>
      VerifyOtpCertificate(
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
  final bool? result;

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
