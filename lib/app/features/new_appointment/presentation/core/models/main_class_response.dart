// To parse this JSON data, do
//
//     final mainClassResponse = mainClassResponseFromJson(jsonString);

import 'dart:convert';

MainClassResponse mainClassResponseFromJson(String str) =>
    MainClassResponse.fromJson(json.decode(str));

String mainClassResponseToJson(MainClassResponse data) =>
    json.encode(data.toJson());

class MainClassResponse {
  MainClassResponse({
    this.statusDetails,
    this.data,
  });

  StatusDetail? statusDetails;
  Data? data;

  factory MainClassResponse.fromJson(Map<String, dynamic> json) =>
      MainClassResponse(
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
  List<MainClassItem>? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] != null
            ? List<MainClassItem>.from(
                json["result"].map((x) => MainClassItem.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class MainClassItem {
  MainClassItem({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory MainClassItem.fromJson(Map<String, dynamic> json) => MainClassItem(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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
