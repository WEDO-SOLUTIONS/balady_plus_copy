import 'package:equatable/equatable.dart';

import '../../municipal_advisor_exports.dart'
    show BoardsParamsModel, PermitsParamsModel;

class FinancialStudyParamsModel extends Equatable {
  final String consultationKey;
  final int licensePeriod;
  final num shopArea;
  final String? cleanOption;
  final int? unitCount;
  final int? accommodationTypeId;
  final List<PermitsParamsModel> permits;
  final List<BoardsParamsModel> boards;
  final bool? atmFeesPaid;

  const FinancialStudyParamsModel({
    required this.consultationKey,
    required this.licensePeriod,
    required this.shopArea,
    required this.cleanOption,
    required this.unitCount,
    required this.accommodationTypeId,
    required this.permits,
    required this.boards,
    required this.atmFeesPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'licensePeriod': licensePeriod,
      'shopArea': shopArea,
      'cleanOption': cleanOption,
      'unitCount': unitCount,
      'accommodationTypeId': accommodationTypeId,
      'permits': permits.map((x) => x.toMap()).toList(),
      'boards': boards.map((x) => x.toMap()).toList(),
      'atmFeesPaid': atmFeesPaid,
    };
  }

  @override
  List<Object?> get props => [
        consultationKey,
        licensePeriod,
        shopArea,
        cleanOption,
        unitCount,
        accommodationTypeId,
        permits,
        boards,
        atmFeesPaid,
      ];
}
