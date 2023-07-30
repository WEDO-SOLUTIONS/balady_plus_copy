part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class SendOTPEvent extends OtpEvent {
  SendOTPParamas params;
  SendOTPEvent({required this.params});
}

class VerifyOTPEvent extends OtpEvent {
  OTPVerifyParamas params;
  VerifyOTPEvent({required this.params});
}
