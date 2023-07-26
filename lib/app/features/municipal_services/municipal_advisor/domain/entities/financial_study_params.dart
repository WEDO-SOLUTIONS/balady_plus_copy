import '../../municipal_advisor_exports.dart' show FinancialStudyParamsModel;

class FinancialStudyParams extends FinancialStudyParamsModel {
  const FinancialStudyParams({
    required super.consultationKey,
    required super.licensePeriod,
    required super.shopArea,
    required super.cleanOption,
    required super.unitCount,
    required super.accommodationTypeId,
    required super.permits,
    required super.boards,
    required super.atmFeesPaid,
  });
}
