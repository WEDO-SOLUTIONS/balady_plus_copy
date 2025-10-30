import 'package:equatable/equatable.dart';

import '../../municipal_advisor_exports.dart' show CostInfoEntity;

class CalculatedFeesEntity extends Equatable {
  final num totalCost;
  final List<CostInfoEntity> costsInfo;
  // final dynamic detailedCostList;
  final int paymentYearsCount;
  final int renewYearsCount;

  const CalculatedFeesEntity({
    required this.totalCost,
    required this.costsInfo,
    // required this.detailedCostList,
    required this.paymentYearsCount,
    required this.renewYearsCount,
  });

  @override
  List<Object?> get props => [
        totalCost,
        costsInfo,
        // detailedCostList,
        paymentYearsCount,
        renewYearsCount,
      ];
}
