// To parse this JSON data, do
//
//     final latestUserRatingResponse = latestUserRatingResponseFromJson(jsonString);

import 'dart:convert';

LatestUserRatingResponse latestUserRatingResponseFromJson(String str) =>
    LatestUserRatingResponse.fromJson(json.decode(str));

String latestUserRatingResponseToJson(LatestUserRatingResponse data) =>
    json.encode(data.toJson());

class LatestUserRatingResponse {
  LatestUserRatingResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory LatestUserRatingResponse.fromJson(Map<String, dynamic> json) =>
      LatestUserRatingResponse(
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
  Result? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": result == null ? null : result!.toJson(),
      };
}

class Result {
  Result({
    this.ratingId,
    this.ratingDate,
    this.notes,
    this.userIdentityId,
    this.userIdentityType,
    this.userName,
    this.ratingDetils,
  });

  int? ratingId;
  String? ratingDate;
  dynamic notes;
  String? userIdentityId;
  int? userIdentityType;
  String? userName;
  List<RatingDetil>? ratingDetils;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        ratingId: json["ratingId"],
        ratingDate: json["ratingDate"],
        notes: json["notes"],
        userIdentityId: json["userIdentityId"],
        userIdentityType: json["userIdentityType"],
        userName: json["userName"],
        ratingDetils: json["ratingDetils"] == null
            ? null
            : List<RatingDetil>.from(
                json["ratingDetils"].map((x) => RatingDetil.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ratingId": ratingId,
        "ratingDate": ratingDate,
        "notes": notes,
        "userIdentityId": userIdentityId,
        "userIdentityType": userIdentityType,
        "userName": userName,
        "ratingDetils": ratingDetils == null
            ? null
            : List<dynamic>.from(ratingDetils!.map((x) => x.toJson())),
      };
}

class RatingDetil {
  RatingDetil({
    this.key,
    this.value,
    this.name,
    this.ename,
    this.average,
  });

  int? key;
  int? value;
  String? name;
  String? ename;
  dynamic average;

  factory RatingDetil.fromJson(Map<String, dynamic> json) => RatingDetil(
        key: json["key"],
        value: json["value"],
        name: json["name"],
        ename: json["ename"],
        average: json["average"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "name": name,
        "ename": ename,
        "average": average,
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
