import '../../municipal_advisor_exports.dart'
    show CalculatedFeesEntity, CostInfoModel;

class CalculatedFeesModel extends CalculatedFeesEntity {
  const CalculatedFeesModel({
    required super.totalCost,
    required super.costsInfo,
    // required super.detailedCostList,
    required super.paymentYearsCount,
    required super.renewYearsCount,
  });

  factory CalculatedFeesModel.fromMap(Map<String, dynamic> map) {
    return CalculatedFeesModel(
      totalCost: map['TotalCost'] as num,
      costsInfo: (map['CostsInfo'] as List<dynamic>)
          .map((e) => CostInfoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      // detailedCostList: map['DetailedCostList'] as List<dynamic>,
      paymentYearsCount: map['PaymentYearsCount'] as int,
      renewYearsCount: map['RenewYearsCount'] as int,
    );
  }
}
