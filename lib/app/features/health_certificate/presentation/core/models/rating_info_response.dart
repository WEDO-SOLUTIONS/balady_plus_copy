// To parse this JSON data, do
//
//     final ratingInfoResponse = ratingInfoResponseFromJson(jsonString);

import 'dart:convert';

RatingInfoResponse ratingInfoResponseFromJson(String str) =>
    RatingInfoResponse.fromJson(json.decode(str));

String ratingInfoResponseToJson(RatingInfoResponse data) =>
    json.encode(data.toJson());

class RatingInfoResponse {
  RatingInfoResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory RatingInfoResponse.fromJson(Map<String, dynamic> json) =>
      RatingInfoResponse(
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
    this.requestType,
    this.ratingCount,
    this.rating,
  });

  int? requestType;
  dynamic ratingCount;
  dynamic rating;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
      requestType: json["requestType"],
      ratingCount: json["ratingCount"],
      rating: json["rating"]);

  Map<String, dynamic> toJson() => {
        "requestType": requestType,
        "ratingCount": ratingCount,
        "rating": rating,
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
