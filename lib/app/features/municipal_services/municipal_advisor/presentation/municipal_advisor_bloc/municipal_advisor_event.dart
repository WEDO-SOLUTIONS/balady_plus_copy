part of 'municipal_advisor_bloc.dart';

abstract class MunicipalAdvisorEvent extends Equatable {
  const MunicipalAdvisorEvent();

  @override
  List<Object?> get props => [];
}

class MunicipalAdvisorAddMessageEvent extends MunicipalAdvisorEvent {
  final String message;
  final MunicipalAdvisorSteps step;
  final dynamic data;

  const MunicipalAdvisorAddMessageEvent({
    required this.message,
    required this.step,
    this.data,
  });

  @override
  List<Object?> get props => [message, step, data];
}

class MunicipalAdvisorRemoveLastChatEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetIsicActivitiesEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorSelectIsicActivityEvent extends MunicipalAdvisorEvent {
  final IsicActivityEntity isicActivity;

  const MunicipalAdvisorSelectIsicActivityEvent({
    required this.isicActivity,
  });

  @override
  List<Object?> get props => [isicActivity];
}

class MunicipalAdvisorGetIsicSubActivitiesEvent extends MunicipalAdvisorEvent {
  final IsicSubActivityParams params;

  const MunicipalAdvisorGetIsicSubActivitiesEvent({
    required this.params,
  });

  @override
  List<Object?> get props => [params];
}

class MunicipalAdvisorSelectIsicSubActivityEvent extends MunicipalAdvisorEvent {
  final IsicActivityEntity isicSubActivity;

  const MunicipalAdvisorSelectIsicSubActivityEvent({
    required this.isicSubActivity,
  });

  @override
  List<Object?> get props => [isicSubActivity];
}

class MunicipalAdvisorGetActivityDetailsEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorRetryEvent extends MunicipalAdvisorEvent {}
