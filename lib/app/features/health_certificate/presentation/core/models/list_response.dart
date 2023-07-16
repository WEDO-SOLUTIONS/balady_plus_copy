// To parse this JSON data, do
//
//     final myRequestsResponse = myRequestsResponseFromJson(jsonString);

import 'dart:convert';

class ListResponse {
  ListResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory ListResponse.fromJson(Map<String, dynamic> json,
          {bool city = false}) =>
      ListResponse(
        statusDetails: json["statusDetails"] == null
            ? null
            : List<StatusDetail>.from(
                json["statusDetails"].map((x) => StatusDetail.fromJson(x))),
        data: json["data"] == null
            ? null
            : Data.fromJson(json["data"], city: city),
      );
}

class Data {
  Data({
    this.responseCode,
    this.responseMessage,
    this.result,
  });

  String? responseCode;
  String? responseMessage;
  List<ListItem>? result;

  factory Data.fromJson(Map<String, dynamic> json, {bool city = false}) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] == null
            ? []
            : List<ListItem>.from(
                json["result"].map((x) => ListItem.fromJson(x, city: city))),
      );
}

class ListItem {
  ListItem({this.id, this.name, this.idNumber});

  final String? id;
  final String? name;
  final int? idNumber;

  factory ListItem.fromJson(Map<String, dynamic> json, {bool city = false}) {
    int? id = city == true ? json["cityId"] : json["id"];
    String? name = city == true ? json["cityName"] : json["name"];
    return ListItem(
        idNumber: id, id: id != null ? id.toString() : null, name: name);
  }
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
