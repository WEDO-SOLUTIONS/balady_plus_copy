import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../../invoices_exports.dart'
    show
        GetInvoiceDetails,
        InvoiceDetailsEntity,
        InvoiceDetailsParams,
        InvoiceEntity;

part 'invoice_details_state.dart';

class InvoiceDetailsCubit extends Cubit<InvoiceDetailsState> {
  final GetInvoiceDetails getInvoiceDetails;

  InvoiceDetailsCubit(
    this.getInvoiceDetails,
  ) : super(const InvoiceDetailsState());

  Future<void> getInvoiceDetailsById(String id) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final params = InvoiceDetailsParams(invoiceId: id);
    final failureOrSuccess = await getInvoiceDetails(params);
    failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: failure.toString(),
          ),
        );
      },
      (invoice) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            invoice: invoice,
          ),
        );
      },
    );
  }
}
