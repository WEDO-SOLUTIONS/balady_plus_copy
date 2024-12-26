import 'dart:convert';

import '../../commercial_license_exports.dart'
    show CrCalculateFeesResponse, ActivitiesCostDetaile, CostsInfo;

class CalculateFeesResponseModel {
  final double? totalCost;
  final List<CostsInfoModel>? costsInfo;
  final dynamic detailedCostList;
  final int? paymentYearsCount;
  final int? renewYearsCount;
  final List<ActivitiesCostDetaileModel>? activitiesCostDetailes;

  CalculateFeesResponseModel({
    this.totalCost,
    this.costsInfo,
    this.detailedCostList,
    this.paymentYearsCount,
    this.renewYearsCount,
    this.activitiesCostDetailes,
  });

  factory CalculateFeesResponseModel.fromJson(Map<String, dynamic> json) =>
      CalculateFeesResponseModel(
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

class ActivitiesCostDetaileModel{
  final String? refrence;
  final double? activtyCost;
  final double? cleaningCost;

  ActivitiesCostDetaileModel({
    this.refrence,
    this.activtyCost,
    this.cleaningCost,
  });

  factory ActivitiesCostDetaileModel.fromJson(Map<String, dynamic> json) =>
      ActivitiesCostDetaileModel(
        refrence: json["Refrence"],
        activtyCost: json["ActivtyCost"]?.toDouble(),
        cleaningCost: json["CleaningCost"]?.toDouble(),
      );
}

class CostsInfoModel {
  final String? costItemDescription;
  final int? costItemTypeId;
  final double? costItemValue;

  CostsInfoModel({
    this.costItemDescription,
    this.costItemTypeId,
    this.costItemValue,
  });

  factory CostsInfoModel.fromJson(Map<String, dynamic> json) => CostsInfoModel(
        costItemDescription: json["CostItemDescription"],
        costItemTypeId: json["CostItemTypeId"],
        costItemValue: json["CostItemValue"]?.toDouble(),
      );
}
