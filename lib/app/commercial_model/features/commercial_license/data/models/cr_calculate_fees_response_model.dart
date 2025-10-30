import 'dart:convert';

import '../../commercial_license_exports.dart'
    show CrCalculateFeesResponse, ActivitiesCostDetaile, CostsInfo;

class CrCalculateFeesResponseModel extends CrCalculateFeesResponse {
  CrCalculateFeesResponseModel({
    super.totalCost,
    super.costsInfo,
    super.detailedCostList,
    super.paymentYearsCount,
    super.renewYearsCount,
    super.activitiesCostDetailes,
  });

  factory CrCalculateFeesResponseModel.fromJson(Map<String, dynamic> json) =>
      CrCalculateFeesResponseModel(
        totalCost: json["TotalCost"]?.toDouble(),
        costsInfo: json["CostsInfo"] == null
            ? []
            : List<CostsInfoModel>.from(
                json["CostsInfo"]!.map((x) => CostsInfoModel.fromJson(x))),
        detailedCostList: json["DetailedCostList"],
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
    super.refrence,
    super.activtyCost,
    super.cleaningCost,
  });

  factory ActivitiesCostDetaileModel.fromJson(Map<String, dynamic> json) =>
      ActivitiesCostDetaileModel(
        refrence: json["Refrence"],
        activtyCost: json["ActivtyCost"]?.toDouble(),
        cleaningCost: json["CleaningCost"]?.toDouble(),
      );
}

class CostsInfoModel extends CostsInfo {
  CostsInfoModel({
    super.costItemDescription,
    super.costItemTypeId,
    super.costItemValue,
  });

  factory CostsInfoModel.fromJson(Map<String, dynamic> json) => CostsInfoModel(
        costItemDescription: json["CostItemDescription"],
        costItemTypeId: json["CostItemTypeId"],
        costItemValue: json["CostItemValue"]?.toDouble(),
      );
}
