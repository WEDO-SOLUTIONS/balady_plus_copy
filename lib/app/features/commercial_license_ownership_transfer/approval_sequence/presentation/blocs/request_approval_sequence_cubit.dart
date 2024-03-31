import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../Commercial_license_transfer/domain/use_cases/get_license_permits_data.dart';
import '../../../../Commercial_license_transfer/persentation/bloc/license_tranfer_cubit.dart';
import '../../data/models/request_permits_model/permit.dart';
import '../../data/models/request_permits_model/request_permits_model.dart';
import '../../domain/repositories/repository.dart';

part 'request_approval_sequence_state.dart';

class RequestApprovalSequenceCubit extends Cubit<RequestApprovalSequenceState> {
  RequestApprovalSequenceRepository requestApprovalSequenceRepository;
  int? requestNumber;
  bool isChecked;

  //  TransferLicenseRequest request= TransferLicenseRequest();
  RequestApprovalSequenceCubit(
      {required this.requestApprovalSequenceRepository,
      required this.isChecked})
      : super(RequestApprovalSequenceState()) {
    getRequestPermits;
  }

  Future<void> getRequestPermits(
    int requestNumber,
    /*TransferLicenseRequest request*/
  ) async {
    emit(LoadingState());
    final failureOrSuccess = await requestApprovalSequenceRepository
        .getRequestPermits(requestNumber);
    failureOrSuccess.fold(
      (failure) {
        if (failure is NoDataFoundException) {
          emit(EmptyState());
        } else if (failure is ServerFailure) {
          emit(FailureState(failureMessage: failure.errorMessage));
        } else {
          emit(FailureState(failureMessage: "error"));
        }
      },
      (requestPermitsModel) {
        emit(SucceedState(permitsList: requestPermitsModel!));
      },
    );
  }
}
