
class CrCalculateFeesResponse {
  final double? totalCost;
  final List<CostsInfo>? costsInfo;
  final dynamic detailedCostList;
  final int? paymentYearsCount;
  final int? renewYearsCount;
  final List<ActivitiesCostDetaile>? activitiesCostDetailes;

  CrCalculateFeesResponse({
    this.totalCost,
    this.costsInfo,
    this.detailedCostList,
    this.paymentYearsCount,
    this.renewYearsCount,
    this.activitiesCostDetailes,
  });
}

class ActivitiesCostDetaile {
  final String? refrence;
  final int? activtyCost;
  final int? cleaningCost;

  ActivitiesCostDetaile({
    this.refrence,
    this.activtyCost,
    this.cleaningCost,
  });
}

class CostsInfo {
  final String? costItemDescription;
  final int? costItemTypeId;
  final double? costItemValue;

  CostsInfo({
    this.costItemDescription,
    this.costItemTypeId,
    this.costItemValue,
  });
}
