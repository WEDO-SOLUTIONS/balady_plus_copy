part of 'otp_bloc.dart';

class OtpState extends Equatable {
  BlocStatus status;
  String? errorMessage;
  SendOTPResponse? sendOTPResponse;
  OtpState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.sendOTPResponse});

  OtpState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      SendOTPResponse? sendOTPResponse}) {
    return OtpState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        sendOTPResponse: sendOTPResponse ?? this.sendOTPResponse);
  }

  @override
  List<Object> get props => [status];
}
