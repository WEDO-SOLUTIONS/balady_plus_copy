// To parse this JSON data, do
//
//     final violatorResponse = violatorResponseFromJson(jsonString);

import 'dart:convert';

ViolatorResponse violatorResponseFromJson(String str) =>
    ViolatorResponse.fromJson(json.decode(str));

String violatorResponseToJson(ViolatorResponse data) =>
    json.encode(data.toJson());

class ViolatorResponse {
  final List<ViolatorItem>? result;

  ViolatorResponse({
    this.result,
  });

  factory ViolatorResponse.fromJson(Map<String, dynamic> json) =>
      ViolatorResponse(
        result: json["result"] == null
            ? []
            : List<ViolatorItem>.from(
                json["result"]!.map((x) => ViolatorItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class ViolatorItem {
  final String? violatorIdNumber;
  final String? violatorType;

  ViolatorItem({
    this.violatorIdNumber,
    this.violatorType,
  });

  factory ViolatorItem.fromJson(Map<String, dynamic> json) => ViolatorItem(
        violatorIdNumber: json["ViolatorIDNumber"],
        violatorType: json["ViolatorType"],
      );

  Map<String, dynamic> toJson() => {
        "ViolatorIDNumber": violatorIdNumber,
        "ViolatorType": violatorType,
      };
}
