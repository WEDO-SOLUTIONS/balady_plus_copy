import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:balady_plus/app/core/errors/failures.dart';
import '../../data/model/apply_request_data_model.dart';
import '../../data/model/permits_response_data_model.dart';
import '../../data/model/validate_license_data_model.dart';
import '../../data/model/validate_owner_data_model.dart';
import '../../domain/entity/transfer_license_request.dart';
import '../../domain/use_cases/get_license_permits_data.dart';
import '../../domain/use_cases/get_validate_license.dart';
import '../../domain/use_cases/get_validate_new_owner.dart';
import '../../domain/use_cases/post_to_new_owner.dart';

part 'license_transfer_state.dart';

class LicenseTransferCubit extends Cubit<LicenseTransferState> {
  GetLicensePermitsData? getLicensePermitsData;
  GetValidateNewOwner? getValidateNewOwner;
  GetValidateLicense? getValidateLicense;
  PostToNewOwner? postToNewOwner;

  String? licenseNumber;
  String? crNumber;

  TransferLicenseRequest request = TransferLicenseRequest();

  LicenseTransferCubit(this.getLicensePermitsData, this.getValidateNewOwner,
      this.getValidateLicense, this.postToNewOwner)
      : super(const LicenseTransferState()) {}

  Future<void> getLicensePermitsDetails(String licenseNumber) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final failureOrSuccess = await getLicensePermitsData!((licenseNumber,));
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
            permits: (licensePermitResponse.data!.result)
                as PermitsResponseDataModel,
          ),
        );
      },
    );
  }

  Future<void> validateNewOwner(String licenseNumber, String crNumber) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final failureOrSuccess =
        await getValidateNewOwner!((licenseNumber, crNumber));
    failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            validateOwner: (response.data!.result) as ValidateOwnerDataModel,
          ),
        );
      },
    );
  }

  Future<void> validateLicense(String licenseNumber) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final failureOrSuccess = await getValidateLicense!((licenseNumber,));
    failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            validateLicense:
                (response.data!.result) as ValidateLicenseDataModel,
          ),
        );
      },
    );
  }

  Future<void> sendToNewOwner(
      String licenseNumber, TransferLicenseRequest request) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final failureOrSuccess = await postToNewOwner!((licenseNumber, request));
    failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            applyDataModel: (response.data!.result) as ApplyRequestDataModel,
          ),
        );
      },
    );
  }
}
