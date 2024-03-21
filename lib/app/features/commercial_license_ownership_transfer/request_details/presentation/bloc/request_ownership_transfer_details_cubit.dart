import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/domain/use_cases/get_request_ownership_transfer_details.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'request_ownership_transfer_details_state.dart';

class RequestOwnershipTransferDetailsCubit extends Cubit<RequestOwnershipTransferDetailsState> {
  final GetRequestOwnershipTransferDetails getCommercialLicenseDetails;
  final String commercialLicenseId;

  RequestOwnershipTransferDetailsCubit(
    this.getCommercialLicenseDetails,
    this.commercialLicenseId,
  ) : super(const RequestOwnershipTransferDetailsState()){
    getCommercialLicenseDetailsById(
      commercialLicenseId,
    );
  }

  Future<void> getCommercialLicenseDetailsById(String id) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final failureOrSuccess = await getCommercialLicenseDetails(id);
    failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: failure.toString(),
          ),
        );
      },
      (commercialLicenceDetails) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            commercialLicenceDetails: commercialLicenceDetails,
          ),
        );
      },
    );
  }
}
