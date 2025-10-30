import '../../invoices_exports.dart' show InvoicesParamsModel;

class InvoicesPrams extends InvoicesParamsModel {
  const InvoicesPrams({
    super.unifiedNationalNumber,
    super.identityNumber,
    super.invoiceId,
    super.requestNumber,
    required super.page,
    required super.size,
    super.productId,
    super.requestTypeId,
    super.invoiceStatusId,
    super.sadadDate,
    super.creationDate,
    super.sort,
  });
}
