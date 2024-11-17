class FindGraveResponse {
  final List<FindGraveItem>? result;

  FindGraveResponse({
    this.result,
  });

  factory FindGraveResponse.fromJson(Map<String, dynamic> json) =>
      FindGraveResponse(
        result: json["result"] == null
            ? []
            : List<FindGraveItem>.from(
                json["result"]!.map((x) => FindGraveItem.fromJson(x))),
      );
}

class FindGraveItem {
  final String? deceasedName;
  final String? burialDate;
  final String? cemeteryName;
  final String? cityName;
  final List<GraveLocation>? graveLocation;

  FindGraveItem(
      {this.deceasedName,
      this.burialDate,
      this.cemeteryName,
      this.cityName,
      this.graveLocation});

  factory FindGraveItem.fromJson(Map<String, dynamic> json) => FindGraveItem(
        deceasedName: json["deceasedName"],
        burialDate: json["burialDate"],
        cemeteryName: json["cemeteryName"],
        cityName: json["cityName"],
        graveLocation: json["graveLocation"] == null
            ? []
            : List<GraveLocation>.from(
                json["graveLocation"]!.map((x) => GraveLocation.fromJson(x))),
      );
}

class GraveLocation {
  int? levelId;
  int? propertyId;
  String? propertyValue;
  String? levelName;
  String? propertyName;

  GraveLocation(
      {this.levelId,
      this.propertyId,
      this.propertyValue,
      this.levelName,
      this.propertyName});

  GraveLocation.fromJson(Map<String, dynamic> json) {
    levelId = json['levelId'];
    propertyId = json['propertyId'];
    propertyValue = json['propertyValue'];
    levelName = json['levelName'];
    propertyName = json['propertyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['levelId'] = levelId;
    data['propertyId'] = propertyId;
    data['propertyValue'] = propertyValue;
    data['levelName'] = levelName;
    data['propertyName'] = propertyName;
    return data;
  }
}
