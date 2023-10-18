import 'package:equatable/equatable.dart';

class InvoiceDetailsParamsModel extends Equatable {
  final String invoiceId;
  final String? identityTypeId;
  final String? identityNumber;

  const InvoiceDetailsParamsModel({
    required this.invoiceId,
    this.identityTypeId,
    this.identityNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      if (identityTypeId != null) 'identityTypeId': identityTypeId,
      if (identityNumber != null) 'identityNumber': identityNumber,
      'invoiceId': invoiceId,
    };
  }

  @override
  List<Object?> get props => [invoiceId, identityTypeId, identityNumber];
}
