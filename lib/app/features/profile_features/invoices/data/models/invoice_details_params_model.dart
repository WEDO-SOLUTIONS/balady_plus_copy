import 'package:equatable/equatable.dart';

class InvoiceDetailsParamsModel extends Equatable {
  final String invoiceId;
  final String? identityTypeId;
  final String? identityNumber;
  final String? xSourceApp;

  const InvoiceDetailsParamsModel({
    required this.invoiceId,
    this.identityTypeId,
    this.identityNumber,
    this.xSourceApp,
  });

  Map<String, dynamic> toMap() {
    return {
      if (identityTypeId != null && identityTypeId!.isNotEmpty)
        'identityTypeId': identityTypeId,
      if (identityNumber != null && identityNumber!.isNotEmpty)
        'identityNumber': identityNumber,
      'invoiceId': invoiceId,
    };
  }

  @override
  List<Object?> get props => [invoiceId, identityTypeId, identityNumber];
}
