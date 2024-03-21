import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/permits_response_data_model.dart';
import '../../domain/use_cases/get_license_permits_data.dart';

part 'license_permits_state.dart';

class LicensePermitsCubit extends Cubit<LicensePermitsState> {
  final GetLicensePermitsData getLicensePermitsData;
  final String licenseNumber;



  LicensePermitsCubit(this.getLicensePermitsData, this.licenseNumber,) : super(const LicensePermitsState()){

    //getLicensePermitsDetails(licenseNumber);
  }

  Future<void> getLicensePermitsDetails( String licenseNumber) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final failureOrSuccess = await getLicensePermitsData((licenseNumber,));
    failureOrSuccess.fold(
          (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: failure.toString(),
          ),
        );
      },
          (licensePermitResponse) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            permits: (licensePermitResponse.data!.result) as PermitsResponseDataModel ,
          ),
        );
      },
    );
  }







}
