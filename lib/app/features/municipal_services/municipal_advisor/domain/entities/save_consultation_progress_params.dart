import '../../municipal_advisor_exports.dart'
    show SaveConsultationProgressParamsModel;

class SaveConsultationProgressParams
    extends SaveConsultationProgressParamsModel {
  const SaveConsultationProgressParams({
    required super.consultationKey,
    required super.subMunicipalityGisCode,
    required super.districtCode,
    required super.streetCode,
    required super.longitude,
    required super.latitude,
    required super.mapNo,
    required super.landNo,
    required super.mainActivityArea,
    required super.activityId,
    required super.atmFeesOption,
    required super.unitCount,
    required super.accommodationTypeId,
    required super.krokiUrl,
  });
}
