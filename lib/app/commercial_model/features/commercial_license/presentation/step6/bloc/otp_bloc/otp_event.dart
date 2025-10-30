part of 'otp_bloc.dart';

abstract class CommercialOTPEvent extends Equatable {
  const CommercialOTPEvent();

  @override
  List<Object> get props => [];
}

class StartSMSListnerEvent extends CommercialOTPEvent {
  StartSMSListnerEvent();
}

class StartTimerEvent extends CommercialOTPEvent {
  StartTimerEvent();
}

class ShowTimerCounterEvent extends CommercialOTPEvent {
  bool? showCounter;
  int? start;
  ShowTimerCounterEvent({this.showCounter, this.start});
}
