import '../../municipal_advisor_exports.dart' show CalculateFeesParamsModel;

class CalculateFeesParams extends CalculateFeesParamsModel {
  const CalculateFeesParams({
    required super.consultationKey,
    required super.municipalityGisCode,
    required super.longitude,
    required super.latitude,
    required super.activityId,
    required super.licensePeriod,
    required super.shopArea,
    required super.mainActivityArea,
    required super.cleanOption,
    required super.unitCount,
    required super.accommodationTypeId,
    required super.permits,
    required super.boards,
    required super.atmFeesPaid,
    required super.additionalActivities,

  });
}
