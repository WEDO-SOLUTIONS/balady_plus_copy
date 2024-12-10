import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import '../../../commercial_license_exports.dart';
import '../../../data/models/isics_main_activity.dart';
import '../../../data/models/save_com_submitter_and_owner_request_model.dart';
import '../../../domain/use_cases/get_main_activities.dart';

part 'step1_applicant_data_export_state.dart';

class Step1ApplicantDataExportCubit extends Cubit<Step1ApplicantDataExportState> {
  final GetRecordInfo _getRecordInfo;
  final AddIsicActivities _addIsicActivities;
  final InitialApprovalApply _saveSubmitterAndOwner;
  final CommercialLicenseInitialExportBloc commercialLicenseBloc;
  final GetMainActivities _GetMainActivities;
  Step1ApplicantDataExportCubit()
      : _getRecordInfo = GetRecordInfo(repository: sl()),
        _addIsicActivities = AddIsicActivities(repository: sl()),
        _GetMainActivities = GetMainActivities(repository: sl()),
        _saveSubmitterAndOwner = InitialApprovalApply(repository: sl()),
        commercialLicenseBloc = sl<CommercialLicenseInitialExportBloc>(),

        super(const Step1ApplicantDataExportState());

  void getRecordInfo() async {

    emit(state.copyWith(recordStatus: BlocStatus.loading));
    final response = await _getRecordInfo((
      CommonProperties.selectedDelegator?.crNumber ??
          CommonProperties.userInfo!.idNo!,
      CommonProperties.selectedDelegator?.getRole() ?? ""
    ));
    response.fold(
        (failure) => emit(state.copyWith(
              recordStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      sl<CommercialLicenseInitialExportBloc>().updateRecordInfo(info: success.data?.result);

      emit(state.copyWith(
          recordStatus: BlocStatus.success, recordInfo: success.data?.result));
    });

  }

  void getMainActivites() async {
    emit(state.copyWith(recordStatus: BlocStatus.loading));
    final response = await _GetMainActivities(state.requestId!);
    response.fold(
            (failure) => emit(state.copyWith(
          recordStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        )), (success) {
      emit(state.copyWith(status: BlocStatus.success,lstMainActivity:success));
      getRecordInfo();


    });

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
    emit(state.copyWith(status: BlocStatus.loading));
    final response = await _saveSubmitterAndOwner(
        SubmitterAndOwnerRequestModel(
            crNumber: CommonProperties.selectedDelegator?.crNumber,
            crType: int.parse(CommonProperties.selectedDelegator!.crType)));

    response.fold(
        (failure) => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      sl<CommercialLicenseInitialExportBloc>()
          .add((UpdateFieldEvent(requestId: success)));

      emit(state.copyWith(status: BlocStatus.success,requestId:success ));
      getMainActivites();

    });
  }
}
