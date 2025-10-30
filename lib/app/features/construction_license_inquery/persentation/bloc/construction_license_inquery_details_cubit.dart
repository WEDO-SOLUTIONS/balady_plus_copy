import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/construction_license_inquery_data_model.dart';
import '../../domain/use_cases/get_construction_license_inquery_data.dart';

part 'construction_license_inquery_details_state.dart';

class ConstructionLicenseInqueryDetailsCubit
    extends Cubit<ConstructionLicenseInqueryDetailsState> {
  final GetConstructionLicenseInqueryData getConstructionLicenseInqueryData;
  final int licenseNumber;
  final String licenseDate;
  //final String licenseType;

  ConstructionLicenseInqueryDetailsCubit(
    this.getConstructionLicenseInqueryData,
    this.licenseNumber,
    this.licenseDate,
    // this.licenseType
  ) : super(const ConstructionLicenseInqueryDetailsState()) {
    getLicenseQueryDetails(licenseNumber, licenseDate);
  }

  Future<void> getLicenseQueryDetails(
      int licenseNumber, String licenseDate) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final failureOrSuccess =
        await getConstructionLicenseInqueryData((licenseNumber, licenseDate));
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
                as ConstructionLicenseDataModel,
          ),
        );
      },
    );
  }
}
