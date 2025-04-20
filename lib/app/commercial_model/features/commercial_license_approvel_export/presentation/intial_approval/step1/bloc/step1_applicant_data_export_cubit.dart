import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/initialApproval/add_isic_activity_data.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';


import '../../../../data/models/initialApproval/isics_main_activity.dart';
import '../../../../data/models/initialApproval/request_details_model.dart';
import '../../../../data/models/initialApproval/save_com_submitter_and_owner_request_model.dart';

import '../../../../domain/use_cases/step1_add_isic_activities.dart';
import '../../../../domain/use_cases/get_initial_approval_request_details.dart';
import '../../../../domain/use_cases/get_main_activities.dart';
import '../../../../domain/use_cases/step1_initial_approval_apply.dart';
import '../../commercial_license/blocs/commercial_license_initial_Approval_bloc.dart';

part 'step1_applicant_data_export_state.dart';

class Step1ApplicantDataExportCubit extends Cubit<Step1ApplicantDataExportState> {
  final getInitialApprovalRequestDetails _getInitialApprovalRequestDetails;
  final AddIsicActivities _addIsicActivities;
  final InitialApprovalApply _saveSubmitterAndOwner;
  final CommercialLicenseInitialAprrovalBloc commercialLicenseBloc;
  final GetMainActivities _GetMainActivities;
  Step1ApplicantDataExportCubit()
      : _getInitialApprovalRequestDetails = getInitialApprovalRequestDetails(repository: sl()),
        _addIsicActivities = AddIsicActivities(repository: sl()),
        _GetMainActivities = GetMainActivities(repository: sl()),
        _saveSubmitterAndOwner = InitialApprovalApply(repository: sl()),
        commercialLicenseBloc = sl<CommercialLicenseInitialAprrovalBloc>(),

        super(const Step1ApplicantDataExportState());

  void getRequestDetails() async {

    emit(state.copyWith(recordStatus: BlocStatus.loading));
    final response = await _getInitialApprovalRequestDetails(state.requestId!);
    response.fold(
        (failure) => emit(state.copyWith(
              recordStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      sl<CommercialLicenseInitialAprrovalBloc>().updateRequestDetails(info: success.data?.result);

      emit(state.copyWith(
          recordStatus: BlocStatus.success, recordInfo: success.data?.result));
    });

  }

  void getMainActivites() async {
    emit(state.copyWith(recordStatus: BlocStatus.loading));
    final response = await _GetMainActivities(state.requestId!);
    response.fold(
            (failure) {
              emit(state.copyWith(recordStatus: BlocStatus.failure, errorMessage: (failure as ServerFailure).errorMessage,));
            }

            , (success) {
      emit(state.copyWith(status: BlocStatus.success,lstMainActivity:success));
      getRequestDetails();


    });

  }


  void addIsicActivities() async {
    emit(state.copyWith(addIsicActivitiesStatus: BlocStatus.loading));
    final response = await _addIsicActivities(AddIsicActivityData(
      crActivities: state.isicActivitiesNotExistInBalady,
      crNumber: state.requestDetails?.owner?.crNumber,
      requestId: state.requestId!,

    ));
    response.fold(
        (failure) => emit(state.copyWith(
              addIsicActivitiesStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )),
        (success) {


            emit(state.copyWith(addIsicActivitiesStatus: BlocStatus.success));



        });
  }


  void initialApprovalApply(int? requestId) async {

    if( requestId == null) {
      emit(state.copyWith(status: BlocStatus.loading));
      final response = await _saveSubmitterAndOwner(
          SubmitterAndOwnerRequestModel(
              crNumber: CommonProperties.selectedDelegator?.crNumber,
              crType: int.parse(CommonProperties.selectedDelegator!.crType)));

      response.fold(
              (failure) {

              emit(state.copyWith(status: BlocStatus.failure));
              CommonFunctions.showError((failure as ServerFailure).errorMessage,true);

                  }, (success) {
        sl<CommercialLicenseInitialAprrovalBloc>().add((UpdateFieldEvent(requestId: success)));

        emit(state.copyWith(status: BlocStatus.success, requestId: success));
        getMainActivites();
      });
    }
    else
      {
        emit(state.copyWith(status: BlocStatus.success, requestId: requestId ));
        getMainActivites();

      }
  }
}
