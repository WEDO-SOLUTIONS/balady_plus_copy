import 'package:equatable/equatable.dart';

class InvoiceEntity extends Equatable {
  final String? id;
  final String accountNumber;
  final String requestNumber;
  final int invoiceStatusId;
  final String invoiceStatusName;
  final String invoiceTypeName;
  final String requestTypeName;
  final num amount;
  final DateTime creationDate;
  final DateTime dueDate;
  final DateTime updatedDate;
  final DateTime? sadadDate;
  final String? redirectUrl;

  const InvoiceEntity({
    required this.id,
    required this.accountNumber,
    required this.requestNumber,
    required this.invoiceStatusId,
    required this.invoiceStatusName,
    required this.invoiceTypeName,
    required this.requestTypeName,
    required this.amount,
    required this.creationDate,
    required this.dueDate,
    required this.sadadDate,
    required this.updatedDate,
    this.redirectUrl,
  });

  @override
  List<Object?> get props => [
        id,
        accountNumber,
        requestNumber,
        invoiceStatusId,
        invoiceStatusName,
        invoiceTypeName,
        requestTypeName,
        amount,
        creationDate,
        dueDate,
        sadadDate,
        updatedDate,
        redirectUrl,
      ];
}
