import '../../invoices_exports.dart' show InvoicesParamsModel;

class InvoicesPrams extends InvoicesParamsModel {
  const InvoicesPrams({
    super.unifiedNationalNumber,
    super.identityNumber,
    super.invoiceNumber,
    super.requestNumber,
    required super.page,
    required super.size,
    super.invoiceTypeId,
    super.invoiceStatusId,
    super.dueDate,
    super.issueDate,
    super.sort,
  });
}
