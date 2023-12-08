import '../../requests_exports.dart' show RequestsParamsModel;

class RequestsPrams extends RequestsParamsModel {
  const RequestsPrams({
    super.unifiedNationalNumber,
    super.identityNumber,
    required super.page,
    required super.size,
    super.requestNumber,
    super.licenceId,
    super.productId,
    super.requestTypeId,
    super.dashboardStatusId,
    super.municipalityId,
    super.subMunicipalityId,
    super.creationDate,
    super.sort,
  });
}
