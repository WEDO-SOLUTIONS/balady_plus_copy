class CalculateRenewDiggingCost {
  int? cityId;
  int? subServiceId;
  double? lastDiggingLicenseCost;
  double? lastDiggingLicensePeriod;
  double? lastDiggingLicenseDistance;
  double? diggingRemainingDistance;
  double? renewDiggingLicensePeriod;

  CalculateRenewDiggingCost(
      {this.cityId,
      this.subServiceId,
      this.lastDiggingLicenseCost,
      this.lastDiggingLicensePeriod,
      this.lastDiggingLicenseDistance,
      this.diggingRemainingDistance,
      this.renewDiggingLicensePeriod});

  factory CalculateRenewDiggingCost.fromJson(Map<String, dynamic> json) =>
      _$CalculateRenewDiggingCostFromJson(json);
  Map<String, dynamic> toJson() => _$CalculateRenewDiggingCostToJson(this);
}

CalculateRenewDiggingCost _$CalculateRenewDiggingCostFromJson(
    Map<String, dynamic> json) {
  return CalculateRenewDiggingCost(
    cityId: json["CityId"],
    subServiceId: json["SubServiceId"],
    lastDiggingLicenseCost: json["LastDiggingLicenseCost"],
    lastDiggingLicensePeriod: json["LastDiggingLicensePeriod"],
    lastDiggingLicenseDistance: json["LastDiggingLicenseDistance"],
    diggingRemainingDistance: json["DiggingRemainingDistance"],
    renewDiggingLicensePeriod: json["RenewDiggingLicensePeriod"],
  );
}

Map<String, dynamic> _$CalculateRenewDiggingCostToJson(
        CalculateRenewDiggingCost instance) =>
    <String, dynamic>{
      "CityId": instance.cityId,
      "SubServiceId": instance.subServiceId,
      "LastDiggingLicenseCost": instance.lastDiggingLicenseCost,
      "LastDiggingLicensePeriod": instance.lastDiggingLicensePeriod,
      "LastDiggingLicenseDistance": instance.lastDiggingLicenseDistance,
      "DiggingRemainingDistance": instance.diggingRemainingDistance,
      "RenewDiggingLicensePeriod": instance.renewDiggingLicensePeriod
    };
