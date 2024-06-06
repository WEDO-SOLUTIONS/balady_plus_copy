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
  final bool? getImage;

  const MunicipalAdvisorGetGisLocationEvent(
      {required this.latLng, this.getImage});

  @override
  List<Object?> get props => [latLng, getImage];
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

class MunicipalAdvisorGetAdditionalActivitiesEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorSelectAdditionalActivitiesEvent
    extends MunicipalAdvisorEvent {
  final List<ActivityDetailsEntity> additionalActivities;

  const MunicipalAdvisorSelectAdditionalActivitiesEvent({
    required this.additionalActivities,
  });

  @override
  List<Object?> get props => [additionalActivities];
}

class MunicipalAdvisorGetActivityDetailsEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetAccommodationTypesEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorSelectAccommodationTypeEvent
    extends MunicipalAdvisorEvent {
  final AccommodationTypeEntity accommodationType;

  const MunicipalAdvisorSelectAccommodationTypeEvent({
    required this.accommodationType,
  });

  @override
  List<Object?> get props => [accommodationType];
}

class MunicipalAdvisorSelectUnitCountEvent extends MunicipalAdvisorEvent {
  final int unitCount;

  const MunicipalAdvisorSelectUnitCountEvent({
    required this.unitCount,
  });

  @override
  List<Object?> get props => [unitCount];
}

class MunicipalAdvisorSelectATMEvent extends MunicipalAdvisorEvent {
  final bool atm;

  const MunicipalAdvisorSelectATMEvent({
    required this.atm,
  });

  @override
  List<Object?> get props => [atm];
}

class MunicipalAdvisorSelectSalamaEvent extends MunicipalAdvisorEvent {
  final bool hasSalama;

  const MunicipalAdvisorSelectSalamaEvent({
    required this.hasSalama,
  });

  @override
  List<Object?> get props => [hasSalama];
}

class MunicipalAdvisorSelectAreaEvent extends MunicipalAdvisorEvent {
  final num area;
  final bool isCostingFrees;

  const MunicipalAdvisorSelectAreaEvent({
    required this.area,
    this.isCostingFrees=false
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

class MunicipalAdvisorGetEngineeringOfficesEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetAdditionalLicenseInfoEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetIssuingPredefinedConditionsEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetLicensePermitsEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetSupervisingAuthoritiesEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorSaveConsultationProgressEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorLoadCalculationLookupsEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorSelectLiceseYearEvent extends MunicipalAdvisorEvent {
  final int year;

  const MunicipalAdvisorSelectLiceseYearEvent({
    required this.year,
  });

  @override
  List<Object?> get props => [year];
}

class MunicipalAdvisorSelectCleaningMechanismEvent
    extends MunicipalAdvisorEvent {
  final CleaningEntity cleaningMechanism;
  final bool calculateFees;

  const MunicipalAdvisorSelectCleaningMechanismEvent({
    required this.cleaningMechanism,
    required this.calculateFees,
  });

  @override
  List<Object?> get props => [
        cleaningMechanism,
        calculateFees,
      ];
}

class MunicipalAdvisorAddCommercialBoardEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorRemoveCommercialBoardEvent extends MunicipalAdvisorEvent {
  final int index;

  const MunicipalAdvisorRemoveCommercialBoardEvent({
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}

class MunicipalAdvisorUpdateCommercialBoardEvent extends MunicipalAdvisorEvent {
  final int index;
  final BoardsParams board;

  const MunicipalAdvisorUpdateCommercialBoardEvent({
    required this.index,
    required this.board,
  });

  @override
  List<Object?> get props => [index, board];
}

class MunicipalAdvisorCalculateLicenseEvent extends MunicipalAdvisorEvent {
  final bool firstCalculation;
  final bool finalCalculation;


  const MunicipalAdvisorCalculateLicenseEvent({
    this.firstCalculation = false,
    this.finalCalculation = false,
  });

  @override
  List<Object?> get props => [firstCalculation, finalCalculation];
}

class MunicipalAdvisorSelectPermitEvent extends MunicipalAdvisorEvent {
  final LicensePermitEntity permit;

  const MunicipalAdvisorSelectPermitEvent({
    required this.permit,
  });

  @override
  List<Object?> get props => [permit];
}

class MunicipalAdvisorUpdateSideWalkEvent extends MunicipalAdvisorEvent {
  final num? length;
  final num? width;
  final int? days;

  const MunicipalAdvisorUpdateSideWalkEvent({
    this.length,
    this.width,
    this.days,
  });

  @override
  List<Object?> get props => [length, width, days];
}

class MunicipalAdvisorUpdateNonFoodVehicleCountEvent
    extends MunicipalAdvisorEvent {
  final int count;

  const MunicipalAdvisorUpdateNonFoodVehicleCountEvent({
    required this.count,
  });

  @override
  List<Object?> get props => [count];
}

class MunicipalAdvisorSaveFinancialStudyEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorContinueToAttachments extends MunicipalAdvisorEvent {
  final bool continueToAttachments;

  const MunicipalAdvisorContinueToAttachments({
    required this.continueToAttachments,
  });

  @override
  List<Object?> get props => [continueToAttachments];
}

class MunicipalAdvisorGetShopOwnershipEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorSelectHasBrandEvent extends MunicipalAdvisorEvent {
  final bool hasBrand;

  const MunicipalAdvisorSelectHasBrandEvent({
    required this.hasBrand,
  });

  @override
  List<Object?> get props => [hasBrand];
}

class MunicipalAdvisorSelectShopOwnershipEvent extends MunicipalAdvisorEvent {
  final ContractEntity shopOwnership;

  const MunicipalAdvisorSelectShopOwnershipEvent({
    required this.shopOwnership,
  });

  @override
  List<Object?> get props => [shopOwnership];
}

class MunicipalAdvisorSelectShopContractOptionEvent
    extends MunicipalAdvisorEvent {
  final ContractOptionEntity shopContractOption;

  const MunicipalAdvisorSelectShopContractOptionEvent({
    required this.shopContractOption,
  });

  @override
  List<Object?> get props => [shopContractOption];
}

class MunicipalAdvisorGetConsultationAttachmentsEvent
    extends MunicipalAdvisorEvent {}

class MunicipalAdvisorContinueToRequestPath extends MunicipalAdvisorEvent {
  final bool continueToRequestPath;

  const MunicipalAdvisorContinueToRequestPath({
    required this.continueToRequestPath,
  });

  @override
  List<Object?> get props => [continueToRequestPath];
}

class AddAddetionalActivityEvent extends MunicipalAdvisorEvent {
  final List<ActivityDetailsEntity> list;

  const AddAddetionalActivityEvent({required this.list});
}

class ChangeAreaInAddetionalActivityEvent extends MunicipalAdvisorEvent {
  final String area;
  final ActivityDetailsEntity activityDetails;

  const ChangeAreaInAddetionalActivityEvent(
      {required this.activityDetails, required this.area});
}

class DeleteAddetionalActivityEvent extends MunicipalAdvisorEvent {
  final ActivityDetailsEntity activityDetails;

  const DeleteAddetionalActivityEvent({required this.activityDetails});
}

class GetImtethalStatusEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetRequestFlowEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorGetCivilDefenceEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorSubmitConsultationEvent extends MunicipalAdvisorEvent {}

class MunicipalAdvisorRetryEvent extends MunicipalAdvisorEvent {}
