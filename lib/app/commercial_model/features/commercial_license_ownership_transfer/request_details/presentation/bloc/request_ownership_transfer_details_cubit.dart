import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/data/models/commercial_licence_details.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/repository.dart';

part 'request_ownership_transfer_details_state.dart';

class RequestOwnershipTransferDetailsCubit
    extends Cubit<RequestOwnershipTransferDetailsState> {
  // final GetRequestOwnershipTransferDetails getCommercialLicenseDetails;
  final RequestOwnershipTransferDetailsRepository
      requestOwnershipTransferDetailsRepository;
  final AcceptOrRejectRequestOwnershipTransferRepository
      acceptOrRejectRequestOwnershipTransferRepository;
  String? requestID;

  RequestOwnershipTransferDetailsCubit(
      {required this.requestOwnershipTransferDetailsRepository,
      required this.acceptOrRejectRequestOwnershipTransferRepository})
      : super(const RequestOwnershipTransferDetailsState()) {}

  Future<void> getCommercialLicenseDetailsById(String id) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final failureOrSuccess = await requestOwnershipTransferDetailsRepository
        .getRequestOwnershipTransferDetails(id);
    failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: (failure as ServerFailure).errorMessage,
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

  Future<String?> acceptCommercialRequestTransfer(String id) async {

    String? Message = null;

    emit(
      state.copyWith(
        status: BlocRequestStatus.submissionUpdateLoading,
        errorMessage: null,
      ),
    );
    final failureOrSuccess = await acceptOrRejectRequestOwnershipTransferRepository.acceptCommercialRequestTransfer(id);
    failureOrSuccess.fold(
      (failure) {


        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ),
        );

      },
      (statusCode)
      {

        Message= "sucessfull";
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionUpdateSuccess,
            errorMessage: null,
          ),
        );


      },
    );
    return Message;
  }

  Future<bool?> rejectCommercialRequestTransfer(String id) async {
   bool? result;

    emit(state.copyWith(
      status: BlocRequestStatus.submissionUpdateLoading,
      errorMessage: null,
    ));
    final failureOrSuccess =
        await acceptOrRejectRequestOwnershipTransferRepository
            .rejectCommercialRequestTransfer(id);
    failureOrSuccess.fold(
      (failure) {
        result= false;
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ),
        );

      },
      (statusCode) {
        result= true;
        emit(state.copyWith(
          status: BlocRequestStatus.submissionUpdateSuccess,
          errorMessage: null,
        ));

      },
    );
   return result;
  }

}
