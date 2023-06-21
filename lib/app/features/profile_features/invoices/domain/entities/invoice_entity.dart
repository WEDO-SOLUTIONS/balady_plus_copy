import 'package:equatable/equatable.dart';

class InvoiceEntity extends Equatable {
  final int requestNumber;
  final int invoiceStatusId;
  final String invoiceStatusName;
  final String invoiceTypeName;
  final String requestTypeName;
  // final String municipalityName;
  // final String subMunicipalityName;
  final num amount;
  final DateTime creationDate;
  final DateTime updatedDate;

  const InvoiceEntity({
    required this.requestNumber,
    required this.invoiceStatusId,
    required this.invoiceStatusName,
    required this.invoiceTypeName,
    required this.requestTypeName,
    // required this.municipalityName,
    // required this.subMunicipalityName,
    required this.amount,
    required this.creationDate,
    required this.updatedDate,
  });

  @override
  List<Object?> get props => [
        requestNumber,
        invoiceStatusId,
        invoiceStatusName,
        invoiceTypeName,
        requestTypeName,
        // municipalityName,
        // subMunicipalityName,
        amount,
        creationDate,
        updatedDate,
      ];
}
