import '../../invoices_exports.dart' show InvoiceDetailsParamsModel;

class InvoiceDetailsParams extends InvoiceDetailsParamsModel {
  const InvoiceDetailsParams({
    required super.invoiceId,
    super.identityNumber,
    super.identityTypeId,
    super.xSourceApp,
  });
}
