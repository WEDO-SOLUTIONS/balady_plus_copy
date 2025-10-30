import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/etmam_app/features/otp/otp_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final SendOTP _sendOTP;
  final VerifyOTP _verifyOTP;
  final String? serviceId;

  OtpBloc({
    required SendOTP sendOTP,
    required VerifyOTP verifyOTP,
    this.serviceId,
    SendOTPResponse? sendOTPResponse,
  })  : _sendOTP = sendOTP,
        _verifyOTP = verifyOTP,
        super(OtpState(sendOTPResponse: sendOTPResponse)) {
    on<OtpEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SendOTPEvent>(_sendOTPHandler);
    on<VerifyOTPEvent>(_verifyOTPHandler);

    if (state.sendOTPResponse == null)
      add(SendOTPEvent(
          params:
              SendOTPParamas(expireSeconds: "60", serviceId: serviceId ?? "")));
  }

  Future<void> _sendOTPHandler(SendOTPEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _sendOTP(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
          status: BlocStatus.success,
          errorMessage: "",
          sendOTPResponse: success.data?.result));
    });
  }

  Future<void> _verifyOTPHandler(VerifyOTPEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _verifyOTP(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));

      // NavigationService.navigatorKey.currentState?.pop(true);
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));
      NavigationService.navigatorKey.currentState?.pop(true);
    });
  }
}
