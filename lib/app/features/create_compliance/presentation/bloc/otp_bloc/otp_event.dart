part of 'otp_bloc.dart';

abstract class ComplianceOTPEvent extends Equatable {
  const ComplianceOTPEvent();

  @override
  List<Object> get props => [];
}

class StartSMSListnerEvent extends ComplianceOTPEvent {
  StartSMSListnerEvent();
}

class StartTimerEvent extends ComplianceOTPEvent {
  StartTimerEvent();
}

class ShowTimerCounterEvent extends ComplianceOTPEvent {
  bool? showCounter;
  int? start;
  ShowTimerCounterEvent({this.showCounter, this.start});
}
