part of 'otp_bloc.dart';

abstract class OTPEvent extends Equatable {
  const OTPEvent();

  @override
  List<Object> get props => [];
}

class StartSMSListnerEvent extends OTPEvent {
  StartSMSListnerEvent();
}

class StartTimerEvent extends OTPEvent {
  StartTimerEvent();
}

class ShowTimerCounterEvent extends OTPEvent {
  bool? showCounter;
  int? start;
  ShowTimerCounterEvent({this.showCounter, this.start});
}
