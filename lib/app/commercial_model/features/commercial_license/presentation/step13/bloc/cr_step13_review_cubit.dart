import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../commercial_license_exports.dart';
import '../../../data/models/conclusion_response_model.dart';
import '../../../domain/entities/cr_submit_request.dart';
import '../../../domain/use_cases/get_commercial_conclusion.dart';
import '../../../domain/use_cases/submit_cr.dart';

part 'cr_step13_review_state.dart';

class CrStep13ReviewDataCubit extends Cubit<CrStep13ReviewState> {
  final SubmitCR _submitCR;
  final GetCommercialConclusion _getCommercialConclusion;

  CrStep13ReviewDataCubit()
      : _submitCR = SubmitCR(repository: sl()),
        _getCommercialConclusion = GetCommercialConclusion(repository: sl()),
        super(const CrStep13ReviewState());

  void onSelectSaddadYear(IsicActivity isicActivity) async {}

  void getConclusion() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final response = await _getCommercialConclusion(requestId);
    response.fold(
        (failure) => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(status: BlocStatus.success, conclusion: success));
    });
  }

  void save() async {
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.CommercialLicense_Send_Request_Event);
    try {
      int requestId = sl<CommercialLicenseBloc>().state.requestId!;
      String saddadPeriod = sl<CommercialLicenseBloc>().state.selectedPeriod!;

      emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
      final response = await _submitCR(CrSubmitRequest(
          requestId: requestId, sadadPeriod: int.tryParse(saddadPeriod)));
      response.fold(
          (failure) => emit(state.copyWith(
                status: BlocStatus.failure,
                errorMessage: (failure as ServerFailure).errorMessage,
              )), (success) {
        emit(state.copyWith(status: BlocStatus.success));

        /*    bool Function(Route<dynamic>) predicate =
            ModalRoute.withName(CommercialRouteName.bottomNavigation);
        NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            CommercialRouteName.successRoute, predicate,
            arguments: SuccessScreenArgs(
                type: PAGE_TYPE.renewCommercial,
                fromHomePage: false,
                thanksMessage: success.data?.result?.message));

                */

        NavigationService.navigatorKey.currentState!.popAndPushNamed(
          CommercialRouteName.submitApplicationSuccessfullyNew,
          arguments: (
            "",
            success.data?.result,
            sl<CommercialLicenseBloc>().state.crCalculateFeesResponse?.totalCost
          ),
        );
      });
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
    }
  }
}
