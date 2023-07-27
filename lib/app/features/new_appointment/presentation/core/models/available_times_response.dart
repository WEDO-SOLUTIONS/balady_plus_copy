// To parse this JSON data, do
//
//     final availableTimesResponse = availableTimesResponseFromJson(jsonString);

import 'dart:convert';

AvailableTimesResponse availableTimesResponseFromJson(String str) =>
    AvailableTimesResponse.fromJson(json.decode(str));

String availableTimesResponseToJson(AvailableTimesResponse data) =>
    json.encode(data.toJson());

class AvailableTimesResponse {
  AvailableTimesResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory AvailableTimesResponse.fromJson(Map<String, dynamic> json) =>
      AvailableTimesResponse(
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
  List<TimeItem>? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode:
            json["responseCode"] == null ? null : json["responseCode"],
        responseMessage:
            json["responseMessage"] == null ? null : json["responseMessage"],
        result: json["result"] == null
            ? null
            : List<TimeItem>.from(
                json["result"].map((x) => TimeItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode == null ? null : responseCode,
        "responseMessage": responseMessage == null ? null : responseMessage,
        "result": result == null
            ? null
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class TimeItem {
  TimeItem({this.timeKey, this.timeValue, this.availableTime});

  String? timeKey;
  String? timeValue;
  bool? availableTime;

  factory TimeItem.fromJson(Map<String, dynamic> json) => TimeItem(
      timeKey: json["timeKey"] == null ? null : json["timeKey"],
      timeValue: json["timeValue"] == null ? null : json["timeValue"],
      availableTime: json["availableTime"]);

  Map<String, dynamic> toJson() => {
        "timeKey": timeKey == null ? null : timeKey,
        "timeValue": timeValue == null ? null : timeValue,
        "availableTime": availableTime
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
