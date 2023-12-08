import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart'
    show BlocRequestStatus, CommonProperties;
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

  Future<void> getInvoiceDetailsById(
    String id,
    String? crNumber,
    String? crType,
    String? xSourceApp,
  ) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final identityNumber =
        crNumber ?? CommonProperties.selectedDelegator?.crNumber;
    final identityTypeId = crType ?? CommonProperties.selectedDelegator?.crType;

    final params = InvoiceDetailsParams(
      invoiceId: id,
      identityNumber: identityNumber,
      identityTypeId: identityTypeId,
      xSourceApp: xSourceApp,
    );
    final failureOrSuccess = await getInvoiceDetails(params);
    failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: xSourceApp == null
                ? failure.toString()
                : 'errorInternalServerError'.tr(),
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
