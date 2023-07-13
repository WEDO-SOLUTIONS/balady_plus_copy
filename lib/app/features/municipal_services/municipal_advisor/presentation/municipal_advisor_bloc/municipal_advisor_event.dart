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

class MunicipalAdvisorGetConsultationKeyEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetGisLocationEvent extends MunicipalAdvisorEvent {
  final LatLng latLng;

  const MunicipalAdvisorGetGisLocationEvent({
    required this.latLng,
  });

  @override
  List<Object?> get props => [latLng];
}

class MunicipalAdvisorSelectLocationEvent extends MunicipalAdvisorEvent {
  final ActivityLocation location;

  const MunicipalAdvisorSelectLocationEvent({
    required this.location,
  });

  @override
  List<Object?> get props => [location];
}

class MunicipalAdvisorRemoveLastChatEvent extends MunicipalAdvisorEvent {
  final int count;

  const MunicipalAdvisorRemoveLastChatEvent({
    required this.count,
  });

  @override
  List<Object?> get props => [count];
}

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

class MunicipalAdvisorSelectAreaEvent extends MunicipalAdvisorEvent {
  final num area;

  const MunicipalAdvisorSelectAreaEvent({
    required this.area,
  });

  @override
  List<Object?> get props => [area];
}

class MunicipalAdvisorChangeInfo extends MunicipalAdvisorEvent {
  final bool changeInfo;

  const MunicipalAdvisorChangeInfo({
    required this.changeInfo,
  });

  @override
  List<Object?> get props => [changeInfo];
}

class MunicipalAdvisorContinueToFinancial extends MunicipalAdvisorEvent {
  final bool continueToFinancial;

  const MunicipalAdvisorContinueToFinancial({
    required this.continueToFinancial,
  });

  @override
  List<Object?> get props => [continueToFinancial];
}

class MunicipalAdvisorChangeStepEvent extends MunicipalAdvisorEvent {
  final String message;
  final MunicipalAdvisorSteps step;

  const MunicipalAdvisorChangeStepEvent({
    required this.message,
    required this.step,
  });

  @override
  List<Object?> get props => [message, step];
}

class MunicipalAdvisorGetCivilDefensePredefinedConditionsEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetCleaningMechanismsEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetCommercialOfficesEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetIssuingPredefinedConditionsEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetLicensePermitsEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetSupervisingAuthoritiesEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorSaveConsultationProgressEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorRetryEvent extends MunicipalAdvisorEvent {}
