import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/domain/use_cases/get_commercial_license_details.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'commercial_license_details_state.dart';

class CommercialLicenseDetailsCubit
    extends Cubit<CommercialLicenseDetailsState> {
  final GetCommercialLicenseDetails getCommercialLicenseDetails;
  final int commercialLicenseId;

  CommercialLicenseDetailsCubit(
    this.getCommercialLicenseDetails,
    this.commercialLicenseId,
  ) : super(const CommercialLicenseDetailsState()) {
    getCommercialLicenseDetailsById(
      commercialLicenseId,
    );
  }

  Future<void> getCommercialLicenseDetailsById(int id) async {
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
