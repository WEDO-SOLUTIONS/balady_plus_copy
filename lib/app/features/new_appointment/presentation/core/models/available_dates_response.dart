import 'dart:convert';

import 'available_times_response.dart';

AvailableDatesResponse availableDatesResponseFromJson(String str) =>
    AvailableDatesResponse.fromJson(json.decode(str));

String availableDatesResponseToJson(AvailableDatesResponse data) =>
    json.encode(data.toJson());

class AvailableDatesResponse {
  AvailableDatesResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory AvailableDatesResponse.fromJson(Map<String, dynamic> json,
          {String? currentDraftTime}) =>
      AvailableDatesResponse(
        statusDetails: List<StatusDetail>.from(
            json["statusDetails"].map((x) => StatusDetail.fromJson(x))),
        data: json["data"] != null
            ? Data.fromJson(json["data"], currentDraftTime: currentDraftTime)
            : null,
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
  List<DateItem>? result;

  factory Data.fromJson(Map<String, dynamic> json,
          {String? currentDraftTime}) =>
      Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] != null
            ? List<DateItem>.from(json["result"].map((x) =>
                DateItem.fromJson(x, currentDraftTime: currentDraftTime)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class DateItem {
  DateItem({this.dayName, this.date, this.times});

  String? dayName;
  String? date;
  List<TimeItem>? times;

  factory DateItem.fromJson(Map<String, dynamic> json,
      {String? currentDraftTime}) {
    DateItem date = DateItem(
      dayName: json["dayName"],
      date: json["date"],
      times: json["times"] == null
          ? null
          : List<TimeItem>.from(json["times"].map((x) => TimeItem.fromJson(x))),
    );
    date.times = date.times
            ?.where(
                (e) => e.availableTime == true || e.timeKey == currentDraftTime)
            .toList() ??
        [];
    return date;
  }

  Map<String, dynamic> toJson() => {
        "dayName": dayName,
        "date": date,
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
