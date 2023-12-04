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

  FindGraveItem({
    this.deceasedName,
    this.burialDate,
    this.cemeteryName,
    this.cityName,
  });

  factory FindGraveItem.fromJson(Map<String, dynamic> json) => FindGraveItem(
        deceasedName: json["deceasedName"],
        burialDate: json["burialDate"],
        cemeteryName: json["cemeteryName"],
        cityName: json["cityName"],
      );
}
