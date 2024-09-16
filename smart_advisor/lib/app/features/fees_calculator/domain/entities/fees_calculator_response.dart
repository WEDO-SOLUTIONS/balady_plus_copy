class FeesCalculatorResponse {
  final double? totalFees;
  final List<CalculatedFee>? calculatedFees;
  final List<Item>? items;

  FeesCalculatorResponse({
    this.totalFees,
    this.calculatedFees,
    this.items,
  });
}

class CalculatedFee {
  final int? actionTypeId;
  final String? actionTypeName;
  final CalculatedFees? calculatedFees;

  CalculatedFee({
    this.actionTypeId,
    this.actionTypeName,
    this.calculatedFees,
  });
}

class CalculatedFees {
  final double? totalCost;
  final List<Item>? costsInfo;
  final List<String>? detailedCostList;
  final int? paymentYearsCount;
  final int? renewYearsCount;
  final List<ActivitiesCostDetaile>? activitiesCostDetailes;

  CalculatedFees({
    this.totalCost,
    this.costsInfo,
    this.detailedCostList,
    this.paymentYearsCount,
    this.renewYearsCount,
    this.activitiesCostDetailes,
  });
}

class ActivitiesCostDetaile {
  final double? activtyCost;
  final double? cleaningCost;
  final String? refrence;

  ActivitiesCostDetaile({
    this.activtyCost,
    this.cleaningCost,
    this.refrence,
  });
}

class Item {
  final String? costItemDescription;
  final int? costItemTypeId;
  final double? costItemValue;
  final dynamic serviceTypeId;

  Item({
    this.costItemDescription,
    this.costItemTypeId,
    this.costItemValue,
    this.serviceTypeId,
  });
}
