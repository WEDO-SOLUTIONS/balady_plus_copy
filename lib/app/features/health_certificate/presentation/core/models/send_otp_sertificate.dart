// To parse this JSON data, do
//
//     final sendOtpCertificate = sendOtpCertificateFromJson(jsonString);

import 'dart:convert';

SendOtpCertificate sendOtpCertificateFromJson(String str) =>
    SendOtpCertificate.fromJson(json.decode(str));

String sendOtpCertificateToJson(SendOtpCertificate data) =>
    json.encode(data.toJson());

class SendOtpCertificate {
  final StatusDetails? statusDetails;
  final Data? data;

  SendOtpCertificate({
    this.statusDetails,
    this.data,
  });

  factory SendOtpCertificate.fromJson(Map<String, dynamic> json) =>
      SendOtpCertificate(
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
  final SendOtpCertificateResult? result;

  Data({
    this.responseCode,
    this.responseMessage,
    this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] == null
            ? null
            : SendOtpCertificateResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": result?.toJson(),
      };
}

class SendOtpCertificateResult {
  final String? otpTokenKey;
  final int? maximumTrailsCount;
  final int? validityPeriodInSeconds;

  SendOtpCertificateResult({
    this.otpTokenKey,
    this.maximumTrailsCount,
    this.validityPeriodInSeconds,
  });

  factory SendOtpCertificateResult.fromJson(Map<String, dynamic> json) =>
      SendOtpCertificateResult(
        otpTokenKey: json["otpTokenKey"],
        maximumTrailsCount: json["maximumTrailsCount"],
        validityPeriodInSeconds: json["validityPeriodInSeconds"],
      );

  Map<String, dynamic> toJson() => {
        "otpTokenKey": otpTokenKey,
        "maximumTrailsCount": maximumTrailsCount,
        "validityPeriodInSeconds": validityPeriodInSeconds,
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
