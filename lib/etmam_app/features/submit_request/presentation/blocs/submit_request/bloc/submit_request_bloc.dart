import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/models/success_screen_args.dart';
import 'package:balady_plus/etmam_app/features/otp/otp_exports.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_page_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/use_cases/submit_request.dart';
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;
part 'submit_request_event.dart';
part 'submit_request_state.dart';

class SubmitRequestBloc extends Bloc<SubmitRequestEvent, SubmitRequestState> {
  SubmitRequest _submitRequest;
  RelationBloc? _relationBloc;
  final SendOTP _sendOTP;

  final Function? callBack;
  SubmitRequestBloc(
      {required SubmitRequest submitRequest,
      required SendOTP sendOTP,
      RelationBloc? relationBloc,
      required SubmitPageParams args})
      : _sendOTP = sendOTP,
        _submitRequest = submitRequest,
        _relationBloc = relationBloc,
        callBack = args.callBack,
        super(SubmitRequestState(
          relationId: args.relationId,
          serviceProviderId: args.serviceProviderId,
          serviceProviderName: args.serviceProviderName,
          subRelations: args.subRelations,
          subServiceId: args.subServiceId,
          subServiceName: args.subServiceName,
          changeProvider: args.changeProvider,
          orderId: args.orderId,
        )) {
    on<SubmitRequestEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SubmitEvent>(_submitRequestHandler);

    on<DeleteSubReleation>(_deleteSubRelationHandler);
  }

  Future<void> _submitRequestHandler(SubmitEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    var otpValue;

    if (e.params.changeProvider != true && state.isOTPConfirmed != true) {
      emitter(state.copyWith(status: BlocStatus.loading));

      final failureOrSuccess1 = await _sendOTP(SendOTPParamas(
          expireSeconds: "60", serviceId: e.params.relationId ?? ""));

      ApigeeResponse<SendOTPResponse>? res =
          await failureOrSuccess1.fold((failure) async {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
        return null;
      }, (success) async {
        emitter(state.copyWith(
          status: BlocStatus.success,
          errorMessage: "",
        ));
        return success;
      });

      if (res != null && res.data?.result?.otpId != null)
        otpValue = await NavigationService.navigatorKey.currentState?.pushNamed(
            EtmamRoutesNames.otpRoute,
            arguments: OTPPageParams(
                otpResponse: res.data?.result, serviceId: e.params.relationId));
      else
        return;
    }
    if (otpValue == true ||
        e.params.changeProvider == true ||
        state.isOTPConfirmed == true) {
      emitter(
          state.copyWith(status: BlocStatus.loading, isOTPConfirmed: otpValue));

      final failureOrSuccess = await _submitRequest(e.params);

      await failureOrSuccess.fold((failure) async {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      }, (success) async {
        emitter(state.copyWith(
          status: BlocStatus.success,
          errorMessage: "",
        ));

        if (state.changeProvider == true && callBack != null) {
          int count = 0;
          final value = await NavigationService.navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(
                  EtmamRoutesNames.successRoute, (_) => count++ >= 2,
                  arguments: SuccessScreenArgs(
                      idNumber: success.data?.result?.number,
                      thanksMessage: success.data?.result?.successMessage,
                      changeProvider: true,
                      type: e.params.pageType ?? PageTypes.orderScreen));
          callBack!();
        } else {
          final value = await NavigationService.navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(EtmamRoutesNames.successRoute,
                  ModalRoute.withName(RouteName.bottomNavigation),
                  arguments: SuccessScreenArgs(
                      idNumber: success.data?.result?.number,
                      thanksMessage: success.data?.result?.successMessage,
                      type: PageTypes.orderScreen));
        }
      });
    }
  }

  Future<void> _deleteSubRelationHandler(
      DeleteSubReleation e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    _relationBloc?.add(DeleteRelationItem(id: e.id));
    emitter(state.copyWith(status: BlocStatus.success));
  }
}
