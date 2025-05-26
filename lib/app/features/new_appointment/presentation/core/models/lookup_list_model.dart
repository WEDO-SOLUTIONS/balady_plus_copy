// To parse this JSON data, do
//
//     final lookUpList = lookUpListFromJson(jsonString);

import 'dart:convert';

LookUpList lookUpListFromJson(String str) =>
    LookUpList.fromJson(json.decode(str));

String lookUpListToJson(LookUpList data) => json.encode(data.toJson());

class LookUpList {
  LookUpList({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory LookUpList.fromJson(Map<String, dynamic> json) => LookUpList(
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
  List<LookUpItem>? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"] ?? null,
        responseMessage: json["responseMessage"] ?? null,
        result: json["result"] == null
            ? null
            : List<LookUpItem>.from(
                json["result"].map((x) => LookUpItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode == null ? null : responseCode,
        "responseMessage": responseMessage == null ? null : responseMessage,
        "result": result == null
            ? null
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class LookUpItem {
  LookUpItem(
      {this.id,
        this.strId,
      this.name,
      this.needApproval,
      this.isOther,
      this.fillInfo,
      this.localCountry,
      this.isDisblaed,
      this.maghsalaExist});

  int? id;
  String? strId;
  String? name;
  bool? isOther;
  bool? needApproval;
  bool? fillInfo;
  bool? localCountry;
  bool? isDisblaed;
  bool? maghsalaExist;

  factory LookUpItem.fromJson(Map<String, dynamic> json) => LookUpItem(
      id: json["id"] == null ? null : json["id"],
      name: json["name"] == null ? null : json["name"],
      fillInfo: json["fillInfo"],
      isOther: json["other"],
      needApproval: json["needApproval"],
      maghsalaExist: json["maghsalaExist"],
      localCountry: json["localCountry"]);

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
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
