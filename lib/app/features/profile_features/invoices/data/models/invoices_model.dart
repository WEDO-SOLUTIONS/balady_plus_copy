import '../../invoices_exports.dart';

class InvoicesModel extends InvoiceEntity {
  const InvoicesModel({
    required super.requestNumber,
    required super.invoiceStatusId,
    required super.invoiceStatusName,
    required super.invoiceTypeName,
    required super.requestTypeName,
    required super.amount,
    required super.creationDate,
    required super.updatedDate,
  });

  factory InvoicesModel.fromMap(Map<String, dynamic> json) {
    return InvoicesModel(
      requestNumber: json['requestNumber'] as int,
      invoiceStatusId: json['invoiceStatusId'] as int,
      invoiceStatusName: json['invoiceStatusName'] as String,
      invoiceTypeName: json['invoiceTypeName'] as String? ?? '',
      requestTypeName: json['requestTypeName'] as String? ?? '',
      amount: json['amount'] as num,
      creationDate: DateTime.parse(json['creationDate'] as String),
      updatedDate: DateTime.parse(json['updateTime'] as String),
    );
  }
}
