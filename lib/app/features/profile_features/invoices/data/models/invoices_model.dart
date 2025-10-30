import '../../invoices_exports.dart';

class InvoicesModel extends InvoiceEntity {
  const InvoicesModel({
    required super.id,
    required super.accountNumber,
    required super.requestNumber,
    required super.invoiceStatusId,
    required super.invoiceStatusName,
    required super.invoiceTypeName,
    required super.requestTypeName,
    required super.amount,
    required super.creationDate,
    required super.dueDate,
    required super.sadadDate,
    required super.updatedDate,
    super.redirectUrl,
  });

  factory InvoicesModel.fromMap(Map<String, dynamic> json) {
    return InvoicesModel(
      id: json['hashingInvoiceNumber'] as String?,
      accountNumber: json['accountNumber'] as String? ?? '',
      requestNumber: json['requestId']?.toString() ?? '',
      invoiceStatusId: json['invoiceStatusId'] as int,
      invoiceStatusName: json['invoiceStatusName'] as String,
      invoiceTypeName: json['invoiceTypeName'] as String? ?? '',
      requestTypeName: json['requestTypeName'] as String? ?? '',
      amount: json['amount'] as num? ?? 0,
      creationDate: DateTime.parse(json['creationDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      sadadDate: json['sadadDate'] == null
          ? null
          : DateTime.parse(json['sadadDate'] as String),
      updatedDate: DateTime.parse(json['updateTime'] as String),
      redirectUrl: json['redirectUrl'] as String?,
    );
  }
}
