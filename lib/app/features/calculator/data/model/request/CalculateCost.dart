class CalculateCost {
  int? cityId;
  int? subactivityId;
  double? value;
  int? accommodationTypeId;
  String? period;
  String? unit;
  bool? isDividedArea;
  bool? isAccommodation;
  bool? isVisit;
  int? renewYearsCount;

  CalculateCost(
      {this.cityId,
      this.subactivityId,
      this.value,
      this.accommodationTypeId,
      this.period,
      this.unit,
      this.isDividedArea,
      this.isAccommodation,
      this.isVisit,
      this.renewYearsCount});

  factory CalculateCost.fromJson(Map<String, dynamic> json) =>
      _$CalculateCostFromJson(json);
  Map<String, dynamic> toJson() => _$CalculateCostToJson(this);
}

CalculateCost _$CalculateCostFromJson(Map<String, dynamic> json) {
  return CalculateCost(
    cityId: json["cityId"],
    subactivityId: json["subactivityId"],
    value: json["value"],
    accommodationTypeId: json["accommodationTypeId"],
    period: json["period"],
    unit: json["unit"],
    isDividedArea: json["isDividedArea"],
    isAccommodation: json["isAccommodation"],
    isVisit: json["isVisit"],
    renewYearsCount: json["RenewYearsCount"],
  );
}

Map<String, dynamic> _$CalculateCostToJson(CalculateCost instance) =>
    <String, dynamic>{
      "cityId": instance.cityId,
      "subactivityId": instance.subactivityId,
      "value": instance.value,
      "accommodationTypeId": instance.accommodationTypeId,
      "period": instance.period,
      "unit": instance.unit,
      "isDividedArea": instance.isDividedArea,
      "isAccommodation": instance.isAccommodation,
      "isVisit": instance.isVisit,
      "RenewYearsCount": instance.renewYearsCount,
    };
