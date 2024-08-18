import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/facility_qr/data/qr_details_response.dart';
import '../../data/model/commercial_license_data_model.dart';
import '../../domain/use_cases/get_commercial_license_query_data.dart';

part 'commercial_license_query_details_state.dart';

class CommercialLicenseQueryDetailsCubit
    extends Cubit<CommercialLicenseQueryDetailsState> {
  final GetCommercialLicenseQueryData getCommercialLicenseQueryData;
  final int commercialLicenseNumber;
  final int unifiedFacilityNumber;
  //CommercialLicenseDataModel? objcommercialLicenceDetails,

  CommercialLicenseQueryDetailsCubit(this.getCommercialLicenseQueryData,
      this.commercialLicenseNumber, this.unifiedFacilityNumber)
      : super(const CommercialLicenseQueryDetailsState()) {
    getCommercialLicenseQueryDetails(
        commercialLicenseNumber, unifiedFacilityNumber);
  }

  Future<void> getCommercialLicenseQueryDetails(
      int commercialLicenseNumber, int unifiedFacilityNumber) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final failureOrSuccess = await getCommercialLicenseQueryData(
        (commercialLicenseNumber, unifiedFacilityNumber));
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
            commercialLicenceDetails: (commercialLicenceDetails.data!.result)
                as CommercialLicenseDataModel,
          ),
        );
      },
    );
  }
}
