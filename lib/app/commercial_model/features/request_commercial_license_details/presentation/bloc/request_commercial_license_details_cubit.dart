import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/models/commercial_license_details_model.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/domain/use_cases/get_request_commercial_license_details.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'request_commercial_license_details_state.dart';

class RequestCommercialLicenseDetailsCubit
    extends Cubit<RequestCommercialLicenseDetailsState> {
  final GetRequestCommercialLicenseDetails getRequestCommercialLicenseDetails;
  final int requestId;

  RequestCommercialLicenseDetailsCubit(
    this.getRequestCommercialLicenseDetails,
    this.requestId,
  ) : super(const RequestCommercialLicenseDetailsState()) {
    getRequestCommercialLicenseDetailsById(
      requestId,
    );
  }

  Future<void> getRequestCommercialLicenseDetailsById(int id) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final failureOrSuccess = await getRequestCommercialLicenseDetails(id);
    failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: failure.toString(),
          ),
        );
      },
      (requestCommercialLicenseDetails) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            commercialLicenceDetails: requestCommercialLicenseDetails,
          ),
        );
      },
    );
  }
}
