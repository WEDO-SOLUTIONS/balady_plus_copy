import '../../licenses_exports.dart' show LicensesParamsModel;

class LicensesPrams extends LicensesParamsModel {
  const LicensesPrams({
    super.unifiedNationalNumber,
    super.identityNumber,
    required super.page,
    required super.size,
    super.licenseNumber,
    super.productId,
    // super.licenseNumber,
    // super.requestTypeId,
    super.dashboardStatusId,
    super.municipalityId,
    super.subMunicipalityId,
    super.expireDate,
    super.sort,
  });
}
