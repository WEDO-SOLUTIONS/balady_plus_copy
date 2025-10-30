// To parse this JSON data, do
//
//     final submitNewRequestResponse = submitNewRequestResponseFromJson(jsonString);

import 'dart:convert';

SubmitNewRequestResponse submitNewRequestResponseFromJson(String str) =>
    SubmitNewRequestResponse.fromJson(json.decode(str));

String submitNewRequestResponseToJson(SubmitNewRequestResponse data) =>
    json.encode(data.toJson());

class SubmitNewRequestResponse {
  SubmitNewRequestResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory SubmitNewRequestResponse.fromJson(Map<String, dynamic> json) =>
      SubmitNewRequestResponse(
        statusDetails: List<StatusDetail>.from(
            json["statusDetails"].map((x) => StatusDetail.fromJson(x))),
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "statusDetails":
            List<dynamic>.from(statusDetails!.map((x) => x.toJson())),
        "data": data!.toJson(),
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
        result: json["result"] != null ? Result.fromJson(json["result"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": result!.toJson(),
      };
}

class Result {
  Result({
    this.requestId,
    this.message,
    this.payUrl,
  });

  int? requestId;
  dynamic message;
  dynamic payUrl;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        requestId: json["requestId"],
        message: json["message"],
        payUrl: json["payUrl"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "message": message,
        "payUrl": payUrl,
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
