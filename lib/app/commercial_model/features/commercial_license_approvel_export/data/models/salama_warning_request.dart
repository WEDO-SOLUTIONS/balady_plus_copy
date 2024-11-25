class SalamaWarningRequest {
  final List<Activity>? activities;
  final int? mainActivityId;
  final double? shopArea;

  SalamaWarningRequest({
    this.activities,
    this.mainActivityId,
    this.shopArea,
  });

  factory SalamaWarningRequest.fromJson(Map<String, dynamic> json) =>
      SalamaWarningRequest(
        activities: json["activities"] == null
            ? []
            : List<Activity>.from(
                json["activities"]!.map((x) => Activity.fromJson(x))),
        mainActivityId: json["mainActivityId"],
        shopArea: json["shopArea"],
      );

  Map<String, dynamic> toJson() => {
        "activities": activities == null
            ? []
            : List<dynamic>.from(activities!.map((x) => x.toJson())),
        "mainActivityId": mainActivityId,
        "shopArea": shopArea,
      };
}

class Activity {
  final int? activityId;
  final double? area;

  Activity({
    this.activityId,
    this.area,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        activityId: json["activityId"],
        area: json["area"],
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "area": area,
      };
}
