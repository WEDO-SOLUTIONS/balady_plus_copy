import '../../requests_exports.dart' show RequestsParamsModel;

class RequestsPrams extends RequestsParamsModel {
  const RequestsPrams({
    super.unifiedNationalNumber,
     super.identityNumber,
     super.query,
     super.requestNumber,
     super.licenceId,
     required super.page,
     required super.size,
     super.productId,
     super.requestTypeId,
     super.dashboardStatusId,
     super.municipalityId,
     super.subMunicipalityId,
     super.creationDate,
     super.sort,
  });
}
