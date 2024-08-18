// To parse this JSON data, do
//
//     final permitAlertsResponse = permitAlertsResponseFromJson(jsonString);

import 'dart:convert';

PermitAlertsResponse permitAlertsResponseFromJson(String str) =>
    PermitAlertsResponse.fromJson(json.decode(str));

String permitAlertsResponseToJson(PermitAlertsResponse data) =>
    json.encode(data.toJson());

class PermitAlertsResponse {
  final List<PermitAlertItem>? result;

  PermitAlertsResponse({
    this.result,
  });

  factory PermitAlertsResponse.fromJson(Map<String, dynamic> json) =>
      PermitAlertsResponse(
        result: json["result"] == null
            ? []
            : List<PermitAlertItem>.from(
                json["result"]!.map((x) => PermitAlertItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class PermitAlertItem {
  final String? id;
  final String? name;

  PermitAlertItem({
    this.id,
    this.name,
  });

  factory PermitAlertItem.fromJson(Map<String, dynamic> json) =>
      PermitAlertItem(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
