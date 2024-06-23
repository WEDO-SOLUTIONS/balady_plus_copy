class SaveCancellationReasonResponse {
  CalculatorResponse calculatorResponse;
  String endorsementText;
  int requestId;
  int statusId;
  String statusName;
  int typeId;
  String typeName;

  SaveCancellationReasonResponse({
    required this.calculatorResponse,
    required this.endorsementText,
    required this.requestId,
    required this.statusId,
    required this.statusName,
    required this.typeId,
    required this.typeName,
  });

  factory SaveCancellationReasonResponse.fromJson(Map<String, dynamic> json) =>
      SaveCancellationReasonResponse(
        calculatorResponse:
            CalculatorResponse.fromJson(json["calculatorResponse"]),
        endorsementText: json["endorsementText"] ?? '',
        requestId: json["requestId"] ?? 0,
        statusId: json["statusId"] ?? 0,
        statusName: json["statusName"] ?? '',
        typeId: json["typeId"] ?? 0,
        typeName: json["typeName"] ?? '',
      );
}

class CalculatorResponse {
  List<ActivitiesCostDetaile>? activitiesCostDetailes;
  List<CostsInfo> costsInfo;
  List<String> detailedCostList;
  int paymentYearsCount;
  int renewYearsCount;
  double totalCost;

  CalculatorResponse({
    required this.activitiesCostDetailes,
    required this.costsInfo,
    required this.detailedCostList,
    required this.paymentYearsCount,
    required this.renewYearsCount,
    required this.totalCost,
  });

  factory CalculatorResponse.fromJson(Map<String, dynamic> json) =>
      CalculatorResponse(
        paymentYearsCount: json["PaymentYearsCount"] ?? 0,
        renewYearsCount: json["RenewYearsCount"] ?? 0,
        activitiesCostDetailes: json["ActivitiesCostDetailes"] != null
            ? List<ActivitiesCostDetaile>.from(json["ActivitiesCostDetailes"]
                .map((x) => ActivitiesCostDetaile.fromJson(x)))
            : null,
        costsInfo: List<CostsInfo>.from(
            json["CostsInfo"].map((x) => CostsInfo.fromJson(x))),
        detailedCostList: json["DetailedCostList"] != null
            ? List<String>.from(json["DetailedCostList"].map((x) => x))
            : [],
        totalCost: (json["TotalCost"] ?? 0) + 0.0,
      );
}

class ActivitiesCostDetaile {
  double activtyCost;
  double cleaningCost;
  String refrence;

  ActivitiesCostDetaile({
    required this.activtyCost,
    required this.cleaningCost,
    required this.refrence,
  });

  factory ActivitiesCostDetaile.fromJson(Map<String, dynamic> json) =>
      ActivitiesCostDetaile(
        activtyCost: (json["ActivtyCost"] ?? 0) + 0.0,
        cleaningCost: (json["CleaningCost"] ?? 0) + 0.0,
        refrence: json["Refrence"] ?? '',
      );
}

class CostsInfo {
  String costItemDescription;
  int costItemTypeId;
  double costItemValue;

  CostsInfo({
    required this.costItemDescription,
    required this.costItemTypeId,
    required this.costItemValue,
  });

  factory CostsInfo.fromJson(Map<String, dynamic> json) => CostsInfo(
        costItemDescription: json["CostItemDescription"] ?? '',
        costItemTypeId: json["CostItemTypeId"],
        costItemValue: (json["CostItemValue"] ?? 0) + 0.0,
      );
}
