// To parse this JSON data, do
//
//     final insideZone = insideZoneFromJson(jsonString);

import 'dart:convert';

InsideZone insideZoneFromJson(String str) =>
    InsideZone.fromJson(json.decode(str));

String insideZoneToJson(InsideZone data) => json.encode(data.toJson());

class InsideZone {
  InsideZone({
    this.isIntersecting,
    this.intersectingIds,
  });

  bool? isIntersecting;
  List<String>? intersectingIds;

  factory InsideZone.fromJson(Map<String, dynamic> json) => InsideZone(
        isIntersecting: json["isIntersecting"],
        intersectingIds: json["intersectingIds"] != null
            ? List<String>.from(json["intersectingIds"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "isIntersecting": isIntersecting,
        "intersectingIds": List<dynamic>.from(intersectingIds!.map((x) => x)),
      };
}
