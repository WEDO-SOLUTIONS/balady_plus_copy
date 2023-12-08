// To parse this JSON data, do
//
//     final subClassResponse = subClassResponseFromJson(jsonString);

import 'dart:convert';

SubClassResponse subClassResponseFromJson(String str) =>
    SubClassResponse.fromJson(json.decode(str));

String subClassResponseToJson(SubClassResponse data) =>
    json.encode(data.toJson());

class SubClassResponse {
  SubClassResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory SubClassResponse.fromJson(Map<String, dynamic> json) =>
      SubClassResponse(
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
  List<SubClassItem>? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] != null
            ? List<SubClassItem>.from(
                json["result"].map((x) => SubClassItem.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class SubClassItem {
  SubClassItem({
    this.id,
    this.name,
    this.isOther,
  });

  int? id;
  String? name;
  dynamic isOther;

  factory SubClassItem.fromJson(Map<String, dynamic> json) => SubClassItem(
        id: json["id"],
        name: json["name"],
        isOther: json["isOther"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isOther": isOther,
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
