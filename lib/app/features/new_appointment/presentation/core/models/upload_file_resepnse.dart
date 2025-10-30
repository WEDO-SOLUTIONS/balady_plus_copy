// To parse this JSON data, do
//
//     final uploadFileResponse = uploadFileResponseFromJson(jsonString);

import 'dart:convert';

UploadFileResponse uploadFileResponseFromJson(String str) =>
    UploadFileResponse.fromJson(json.decode(str));

String uploadFileResponseToJson(UploadFileResponse data) =>
    json.encode(data.toJson());

class UploadFileResponse {
  UploadFileResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory UploadFileResponse.fromJson(Map<String, dynamic> json) =>
      UploadFileResponse(
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
    this.id,
    this.uuid,
    this.name,
    this.allowedFilesExtension,
    this.isMandatory,
    this.attached,
    this.approved,
    this.attachUrl,
    this.notes,
    this.updatable,
    this.maxSize,
  });

  int? id;
  String? uuid;
  dynamic name;
  dynamic allowedFilesExtension;
  bool? isMandatory;
  bool? attached;
  bool? approved;
  String? attachUrl;
  dynamic notes;
  bool? updatable;
  dynamic maxSize;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
        allowedFilesExtension: json["allowedFilesExtension"],
        isMandatory: json["isMandatory"],
        attached: json["attached"],
        approved: json["approved"],
        attachUrl: json["attachUrl"],
        notes: json["notes"],
        updatable: json["updatable"],
        maxSize: json["maxSize"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "name": name,
        "allowedFilesExtension": allowedFilesExtension,
        "isMandatory": isMandatory,
        "attached": attached,
        "approved": approved,
        "attachUrl": attachUrl,
        "notes": notes,
        "updatable": updatable,
        "maxSize": maxSize,
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
