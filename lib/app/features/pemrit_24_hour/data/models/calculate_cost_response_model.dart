class CalculateCost24PermitResponse {
  double? totalCost;
  List<CostsInfo>? costsInfo;
  dynamic detailedCostList;
  int? paymentYearsCount;
  int? renewYearsCount;
  dynamic activitiesCostDetailes;

  CalculateCost24PermitResponse({
    this.totalCost,
    this.costsInfo,
    this.detailedCostList,
    this.paymentYearsCount,
    this.renewYearsCount,
    this.activitiesCostDetailes,
  });

  factory CalculateCost24PermitResponse.fromJson(Map<String, dynamic> json) =>
      CalculateCost24PermitResponse(
        totalCost: json["TotalCost"]?.toDouble(),
        costsInfo: json["CostsInfo"] == null
            ? []
            : List<CostsInfo>.from(
                json["CostsInfo"]!.map((x) => CostsInfo.fromJson(x))),
        detailedCostList: json["DetailedCostList"],
        paymentYearsCount: json["PaymentYearsCount"],
        renewYearsCount: json["RenewYearsCount"],
        activitiesCostDetailes: json["ActivitiesCostDetailes"],
      );

  Map<String, dynamic> toJson() => {
        "TotalCost": totalCost,
        "CostsInfo": costsInfo == null
            ? []
            : List<dynamic>.from(costsInfo!.map((x) => x.toJson())),
        "DetailedCostList": detailedCostList,
        "PaymentYearsCount": paymentYearsCount,
        "RenewYearsCount": renewYearsCount,
        "ActivitiesCostDetailes": activitiesCostDetailes,
      };
}

class CostsInfo {
  String? costItemDescription;
  int? costItemTypeId;
  double? costItemValue;

  CostsInfo({
    this.costItemDescription,
    this.costItemTypeId,
    this.costItemValue,
  });

  factory CostsInfo.fromJson(Map<String, dynamic> json) => CostsInfo(
        costItemDescription: json["CostItemDescription"],
        costItemTypeId: json["CostItemTypeId"],
        costItemValue: json["CostItemValue"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "CostItemDescription": costItemDescription,
        "CostItemTypeId": costItemTypeId,
        "CostItemValue": costItemValue,
      };
}
