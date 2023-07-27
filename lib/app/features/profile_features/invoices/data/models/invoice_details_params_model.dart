import 'package:equatable/equatable.dart';

class InvoiceDetailsParamsModel extends Equatable {
  final String invoiceId;

  const InvoiceDetailsParamsModel({
    required this.invoiceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
    };
  }

  @override
  List<Object?> get props => [
        invoiceId,
      ];
}
