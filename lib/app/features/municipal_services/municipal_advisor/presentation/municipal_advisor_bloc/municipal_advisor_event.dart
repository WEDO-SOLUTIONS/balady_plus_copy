part of 'municipal_advisor_bloc.dart';

abstract class MunicipalAdvisorEvent extends Equatable {
  const MunicipalAdvisorEvent();

  @override
  List<Object> get props => [];
}

class MunicipalAdvisorStartChatEvent extends MunicipalAdvisorEvent {
  final String message;
  final MunicipalAdvisorSteps step;

  const MunicipalAdvisorStartChatEvent({
    required this.message,
    required this.step,
  });

  @override
  List<Object> get props => [message, step];
}
