import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/save_location_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step1/page/cr_step1_applicant_data.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step2/page/step2_intial_approval__activity_data.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meta/meta.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import '../../../data/models/initialApproval/request_details_model.dart';
import '../../../domain/use_cases/cancel_intial_approval.dart';
import '../../../domain/use_cases/get_initial_approval_request_details.dart';


part 'commercial_license_details_event.dart';

part 'commercial_license_details_state.dart';

class CommercialLicenseDetailsBloc
    extends Bloc<CommercialLicenseDetailsEvent, CommercialLicenseDetailsState> {
  PageController controller = PageController();
  final int requestId;
  final getInitialApprovalRequestDetails _getInitialApprovalRequestDetails;
  final CancelIntialApproval _cancelIntialApproval;
  CommercialLicenseDetailsBloc(this.requestId)
      : _getInitialApprovalRequestDetails = getInitialApprovalRequestDetails(repository: sl()),
        _cancelIntialApproval = CancelIntialApproval(repository: sl()),
        super(CommercialLicenseDetailsState(requestId: requestId)) {
          getCommercialRequestData();

  }








  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }


  Future<void> getCommercialRequestData() async {
    emit(state.copyWith(status: BlocStatus.loading,));

    final response = await _getInitialApprovalRequestDetails(state.requestId!);
    response.fold(
            (failure) {

              emit(state.copyWith(status: BlocStatus.failure,));

            }

        , (res) {

              emit(state.copyWith(requestDetails: res.data?.result,status:BlocStatus.success ));
    });

  }

  Future<void> cancelIntialApproval() async {
    emit(state.copyWith(status: BlocStatus.loading,));

    final response = await _cancelIntialApproval(state.requestId!);
    response.fold(
            (failure) {
              CommonFunctions.showError("cannotdothisaction".tr());
           emit(state.copyWith(status: BlocStatus.failure,));


        }

        , (res) {

      CommonFunctions.showSuccess("commerical_add_activity_sucessfull".tr());
      emit(state.copyWith(status:BlocStatus.success ));

    });

  }

}
