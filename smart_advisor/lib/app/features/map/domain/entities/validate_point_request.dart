// To parse this JSON data, do
//
//     final validatePointRequest = validatePointRequestFromJson(jsonString);

import 'dart:convert';

ValidatePointRequest validatePointRequestFromJson(String str) =>
    ValidatePointRequest.fromJson(json.decode(str));

String validatePointRequestToJson(ValidatePointRequest data) =>
    json.encode(data.toJson());

class ValidatePointRequest {
  final List<int>? activities;
  final int? requestTypeId;
  final String? x;
  final String? y;

  ValidatePointRequest({
    this.activities,
    this.requestTypeId,
    this.x,
    this.y,
  });

  factory ValidatePointRequest.fromJson(Map<String, dynamic> json) =>
      ValidatePointRequest(
        activities: json["activities"] == null
            ? []
            : List<int>.from(json["activities"]!.map((x) => x)),
        requestTypeId: json["requestTypeId"],
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "activities": activities == null
            ? []
            : List<dynamic>.from(activities!.map((x) => x)),
        "requestTypeId": requestTypeId,
        "x": x,
        "y": y,
      };
}
