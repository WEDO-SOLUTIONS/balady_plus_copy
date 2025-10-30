part of 'invoice_details_cubit.dart';

class InvoiceDetailsState extends Equatable {
  final BlocRequestStatus status;
  final InvoiceDetailsEntity? invoice;
  //error message
  final String? errorMessage;

  const InvoiceDetailsState({
    this.status = BlocRequestStatus.initial,
    this.invoice,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  InvoiceDetailsState copyWith({
    BlocRequestStatus? status,
    InvoiceDetailsEntity? invoice,
    String? errorMessage,
  }) {
    return InvoiceDetailsState(
      status: status ?? this.status,
      invoice: invoice ?? this.invoice,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        invoice,
        errorMessage,
      ];
}
