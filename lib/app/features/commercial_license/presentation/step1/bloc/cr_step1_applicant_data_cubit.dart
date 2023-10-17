import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../commercial_license_exports.dart';
import '../../../data/models/save_com_submitter_and_owner_request_model.dart';

part 'cr_step1_applicant_data_state.dart';

class CrStep1ApplicantDataCubit extends Cubit<CrStep1ApplicantDataState> {
  final GetRecordInfo _getRecordInfo;
  final AddIsicActivities _addIsicActivities;
  final SaveComSubmitterAndOwner _saveComSubmitterAndOwner;
  final CommercialLicenseBloc commercialLicenseBloc;
  CrStep1ApplicantDataCubit()
      : _getRecordInfo = GetRecordInfo(repository: sl()),
        _addIsicActivities = AddIsicActivities(repository: sl()),
        _saveComSubmitterAndOwner = SaveComSubmitterAndOwner(repository: sl()),
        commercialLicenseBloc = sl<CommercialLicenseBloc>(),
        super(const CrStep1ApplicantDataState());

  void getRecordInfo() async {
    emit(state.copyWith(recordStatus: BlocStatus.loading));
    final response = await _getRecordInfo((
      CommonProperties.selectedDelegator!.crNumber!,
      CommonProperties.selectedDelegator!.getRole()
    ));

    /// TODO: UnComment below line
    // final response = await _getRecordInfo(
    //     CommonProperties.selectedDelegator?.crNumber ?? "");
    response.fold(
        (failure) => emit(state.copyWith(
              recordStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )),
        (success) => emit(state.copyWith(
            recordStatus: BlocStatus.success,
            recordInfo: success.data?.result)));
  }

  void addIsicActivities() async {
    emit(state.copyWith(addIsicActivitiesStatus: BlocStatus.loading));
    final response = await _addIsicActivities(AddIsicActivitiesParams(
      crActivities: state.isicActivitiesNotExistInBalady,
      crNumber: state.recordInfo?.crNumber,
      identityNumber: state.recordInfo?.crInfo?.nationalNumber,
      mobileNumber: state.recordInfo?.crInfo?.phoneNo,
    ));

    response.fold(
        (failure) => emit(state.copyWith(
              addIsicActivitiesStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )),
        (success) =>
            emit(state.copyWith(addIsicActivitiesStatus: BlocStatus.success)));
  }

  void saveComSubmitterAndOwner() async {
    emit(state.copyWith(addIsicActivitiesStatus: BlocStatus.loading));
    final response = await _saveComSubmitterAndOwner(
        SaveComSubmitterAndOwnerRequestModel(
            crNumber: state.recordInfo?.crNumber,
            crType: state.recordInfo?.crType,
            entityType: 0 /*state.recordInfo?.crInfo?.entityType*/));

    response.fold(
        (failure) => emit(state.copyWith(
              addIsicActivitiesStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      sl<CommercialLicenseBloc>()
          .add((UpdateRequestFieldEvent(requestId: success)));

      sl<CommercialLicenseBloc>().add((const GoToNextPageEvent()));
      emit(state.copyWith(addIsicActivitiesStatus: BlocStatus.success));
    });
  }
}
