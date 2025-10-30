class CalculateDiggingCost {
  int? cityId;
  int? subServiceId;
  int? diggingPeriod;
  double? diggingDistance;

  CalculateDiggingCost({
    this.cityId,
    this.diggingDistance,
    this.diggingPeriod,
    this.subServiceId,
  });

  factory CalculateDiggingCost.fromJson(Map<String, dynamic> json) =>
      _$CalculateDiggingCostFromJson(json);
  Map<String, dynamic> toJson() => _$CalculateDiggingCostToJson(this);
}

CalculateDiggingCost _$CalculateDiggingCostFromJson(Map<String, dynamic> json) {
  return CalculateDiggingCost(
    cityId: json["CityId"],
    subServiceId: json["SubServiceId"],
    diggingPeriod: json["DiggingPeriod"],
    diggingDistance: json["DiggingDistance"],
  );
}

Map<String, dynamic> _$CalculateDiggingCostToJson(
        CalculateDiggingCost instance) =>
    <String, dynamic>{
      "CityId": instance.cityId,
      "SubServiceId": instance.subServiceId,
      "DiggingPeriod": instance.diggingPeriod,
      "DiggingDistance": instance.diggingDistance,
    };
