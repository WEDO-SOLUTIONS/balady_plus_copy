// To parse this JSON data, do
//
//     final datesList = datesListFromJson(jsonString);

import 'dart:convert';

DatesList datesListFromJson(String str) => DatesList.fromJson(json.decode(str));

String datesListToJson(DatesList data) => json.encode(data.toJson());

class DatesList {
  DatesList({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory DatesList.fromJson(Map<String, dynamic> json) => DatesList(
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
  List<DateItem>? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode:
            json["responseCode"] == null ? null : json["responseCode"],
        responseMessage:
            json["responseMessage"] == null ? null : json["responseMessage"],
        result: json["result"] == null
            ? null
            : List<DateItem>.from(
                json["result"].map((x) => DateItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode == null ? null : responseCode,
        "responseMessage": responseMessage == null ? null : responseMessage,
        "result": result == null
            ? null
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class DateItem {
  DateItem({
    this.dayName,
    this.date,
  });

  String? dayName;
  String? date;

  factory DateItem.fromJson(Map<String, dynamic> json) => DateItem(
        dayName: json["dayName"] == null ? null : json["dayName"],
        date: json["date"] == null ? null : json["date"],
      );

  Map<String, dynamic> toJson() => {
        "dayName": dayName == null ? null : dayName,
        "date": date == null ? null : date,
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
