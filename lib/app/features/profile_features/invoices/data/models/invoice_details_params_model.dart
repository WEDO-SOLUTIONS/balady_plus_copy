import 'package:equatable/equatable.dart';

class InvoiceDetailsParamsModel extends Equatable {
  final String invoiceId;
  final String? unifiedNationalNumber;
  final String? identityNumber;
  const InvoiceDetailsParamsModel({
    required this.invoiceId,
    this.unifiedNationalNumber,
    this.identityNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      if (unifiedNationalNumber != null)
        'unifiedNationalNumber': unifiedNationalNumber,
      if (identityNumber != null) 'identityNumber': identityNumber,
      'invoiceId': invoiceId,
    };
  }

  @override
  List<Object?> get props => [invoiceId, unifiedNationalNumber, identityNumber];
}
