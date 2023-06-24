import 'package:equatable/equatable.dart';

class InvoiceEntity extends Equatable {
  final int requestNumber;
  final int invoiceStatusId;
  final String invoiceStatusName;
  final String invoiceTypeName;
  final String requestTypeName;
  final num amount;
  final DateTime creationDate;
  final DateTime updatedDate;
  final String? redirectUrl;

  const InvoiceEntity({
    required this.requestNumber,
    required this.invoiceStatusId,
    required this.invoiceStatusName,
    required this.invoiceTypeName,
    required this.requestTypeName,
    required this.amount,
    required this.creationDate,
    required this.updatedDate,
    this.redirectUrl,
  });

  @override
  List<Object?> get props => [
        requestNumber,
        invoiceStatusId,
        invoiceStatusName,
        invoiceTypeName,
        requestTypeName,
        amount,
        creationDate,
        updatedDate,
        redirectUrl,
      ];
}
