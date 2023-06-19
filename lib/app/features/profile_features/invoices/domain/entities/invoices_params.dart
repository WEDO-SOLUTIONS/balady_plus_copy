import '../../invoices_exports.dart' show InvoicesParamsModel;

class InvoicesPrams extends InvoicesParamsModel {
  const InvoicesPrams({
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
