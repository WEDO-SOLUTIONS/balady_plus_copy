import '/app/features/fees_calculator/domain/entities/fees_calculator_response.dart';

class FeesCalculatorResponseModel extends FeesCalculatorResponse {
  FeesCalculatorResponseModel({
    super.totalFees,
    super.calculatedFees,
    super.items,
  });

  factory FeesCalculatorResponseModel.fromJson(Map<String, dynamic> json) =>
      FeesCalculatorResponseModel(
        totalFees: json["totalFees"],
        calculatedFees: json["calculatedFees"] == null
            ? []
            : List<CalculatedFeeModel>.from(json["calculatedFees"]!
                .map((x) => CalculatedFeeModel.fromJson(x))),
        items: json["items"] == null
            ? []
            : List<ItemModel>.from(
                json["items"]!.map((x) => ItemModel.fromJson(x))),
      );
}

class CalculatedFeeModel extends CalculatedFee {
  CalculatedFeeModel({
    super.actionTypeId,
    super.actionTypeName,
    super.calculatedFees,
  });

  factory CalculatedFeeModel.fromJson(Map<String, dynamic> json) =>
      CalculatedFeeModel(
          actionTypeId: json["actionTypeId"],
          actionTypeName: json["actionTypeName"],
          calculatedFees: json["calculatedFees"]);
}

class CalculatedFeesModel extends CalculatedFees {
  CalculatedFeesModel({
    super.totalCost,
    super.costsInfo,
    super.detailedCostList,
    super.paymentYearsCount,
    super.renewYearsCount,
    super.activitiesCostDetailes,
  });

  factory CalculatedFeesModel.fromJson(Map<String, dynamic> json) =>
      CalculatedFeesModel(
        totalCost: json["TotalCost"],
        costsInfo: json["CostsInfo"] == null
            ? []
            : List<ItemModel>.from(
                json["CostsInfo"]!.map((x) => ItemModel.fromJson(x))),
        detailedCostList: json["DetailedCostList"] == null
            ? []
            : List<String>.from(json["DetailedCostList"]!.map((x) => x)),
        paymentYearsCount: json["PaymentYearsCount"],
        renewYearsCount: json["RenewYearsCount"],
        activitiesCostDetailes: json["ActivitiesCostDetailes"] == null
            ? []
            : List<ActivitiesCostDetaileModel>.from(
                json["ActivitiesCostDetailes"]!
                    .map((x) => ActivitiesCostDetaileModel.fromJson(x))),
      );
}

class ActivitiesCostDetaileModel extends ActivitiesCostDetaile {
  ActivitiesCostDetaileModel({
    super.activtyCost,
    super.cleaningCost,
    super.refrence,
  });

  factory ActivitiesCostDetaileModel.fromJson(Map<String, dynamic> json) =>
      ActivitiesCostDetaileModel(
        activtyCost: json["ActivtyCost"],
        cleaningCost: json["CleaningCost"],
        refrence: json["Refrence"],
      );

  Map<String, dynamic> toJson() => {
        "ActivtyCost": activtyCost,
        "CleaningCost": cleaningCost,
        "Refrence": refrence,
      };
}

class ItemModel extends Item {
  ItemModel({
    super.costItemDescription,
    super.costItemTypeId,
    super.costItemValue,
    super.serviceTypeId,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        costItemDescription: json["CostItemDescription"],
        costItemTypeId: json["CostItemTypeId"],
        costItemValue: json["CostItemValue"],
        serviceTypeId: json["ServiceTypeId"],
      );

  Map<String, dynamic> toJson() => {
        "CostItemDescription": costItemDescription,
        "CostItemTypeId": costItemTypeId,
        "CostItemValue": costItemValue,
        "ServiceTypeId": serviceTypeId,
      };
}
