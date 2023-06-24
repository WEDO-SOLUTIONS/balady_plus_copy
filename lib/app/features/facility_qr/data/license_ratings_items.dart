// To parse this JSON data, do
//
//     final licenseRatingItems = licenseRatingItemsFromJson(jsonString);

import 'dart:convert';

LicenseRatingItems licenseRatingItemsFromJson(String str) =>
    LicenseRatingItems.fromJson(json.decode(str));

String licenseRatingItemsToJson(LicenseRatingItems data) =>
    json.encode(data.toJson());

class LicenseRatingItems {
  LicenseRatingItems({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory LicenseRatingItems.fromJson(Map<String, dynamic> json) =>
      LicenseRatingItems(
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

  int? responseCode;
  String? responseMessage;
  List<RatingItem>? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] == null
            ? null
            : List<RatingItem>.from(
                json["result"].map((x) => RatingItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": result == null
            ? null
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class RatingItem {
  RatingItem({this.id, this.name, this.ename, this.value});

  int? id;
  String? name;
  String? ename;
  int? value;

  factory RatingItem.fromJson(Map<String, dynamic> json) => RatingItem(
        id: json["id"],
        name: json["name"],
        ename: json["ename"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ename": ename,
      };

  RatingItem copyWith({int? id, String? name, String? ename, int? value}) =>
      RatingItem(
          id: id ?? this.id,
          name: name ?? this.name,
          ename: ename ?? this.ename,
          value: value ?? this.value);
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
