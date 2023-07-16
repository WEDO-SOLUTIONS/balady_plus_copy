// To parse this JSON data, do
//
//     final deleteRequestResponse = deleteRequestResponseFromJson(jsonString);

import 'dart:convert';

DeleteRequestResponse deleteRequestResponseFromJson(String str) =>
    DeleteRequestResponse.fromJson(json.decode(str));

String deleteRequestResponseToJson(DeleteRequestResponse data) =>
    json.encode(data.toJson());

class DeleteRequestResponse {
  DeleteRequestResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory DeleteRequestResponse.fromJson(Map<String, dynamic> json) =>
      DeleteRequestResponse(
        statusDetails: json["statusDetails"] != null
            ? List<StatusDetail>.from(
                json["statusDetails"].map((x) => StatusDetail.fromJson(x)))
            : null,
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
  bool? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": result,
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
