part of 'municipal_advisor_bloc.dart';

class MunicipalAdvisorState extends Equatable {
  final BlocRequestStatus status;
  final List<ChatMessage> messages;
  final String? consultationKey;
  final GISResponse? gisResponse;
  final ActivityLocation? activityLocation;
  final List<IsicActivityEntity> isicActivities;
  final IsicActivityEntity? selectedIsicActivity;
  final List<IsicActivityEntity> isicSubActivities;
  final IsicActivityEntity? selectedIsicSubActivity;
  final ActivityDetailsEntity? activityDetails;
  final List<AccommodationTypeEntity> accommodationTypes;
  final AccommodationTypeEntity? selectedAccommodationType;
  final int? unitCount;
  final bool? atmPaid;
  final num? selectedArea;
  final bool changingInfo;
  final List<String>? issuingPredefinedConditions;
  final List<LicensePermitEntity>? licensePermits;
  final List<SupervisingAuthorityEntity>? supervisingAuthorities;
  final List<String>? civilDefensePredefinedConditions;
  final List<String>? cleaningMechanisms;
  final List<CommercialOfficeEntity>? commercialOffices;
  final MunicipalAdvisorEvent? lastEvent;
  final String? errorMessage;

  const MunicipalAdvisorState({
    this.status = BlocRequestStatus.initial,
    this.messages = const <ChatMessage>[],
    this.consultationKey,
    this.gisResponse,
    this.activityLocation,
    this.isicActivities = const <IsicActivityEntity>[],
    this.selectedIsicActivity,
    this.isicSubActivities = const <IsicActivityEntity>[],
    this.selectedIsicSubActivity,
    this.activityDetails,
    this.accommodationTypes = const <AccommodationTypeEntity>[],
    this.selectedAccommodationType,
    this.unitCount,
    this.atmPaid,
    this.selectedArea,
    this.changingInfo = false,
    this.issuingPredefinedConditions,
    this.licensePermits,
    this.supervisingAuthorities,
    this.civilDefensePredefinedConditions,
    this.cleaningMechanisms,
    this.commercialOffices,
    this.lastEvent,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  MunicipalAdvisorState copyWith({
    BlocRequestStatus? status,
    List<ChatMessage>? messages,
    String? consultationKey,
    GISResponse? gisResponse,
    ActivityLocation? activityLocation,
    List<IsicActivityEntity>? isicActivities,
    IsicActivityEntity? selectedIsicActivity,
    List<IsicActivityEntity>? isicSubActivities,
    IsicActivityEntity? selectedIsicSubActivity,
    ActivityDetailsEntity? activityDetails,
    List<AccommodationTypeEntity>? accommodationTypes,
    AccommodationTypeEntity? selectedAccommodationType,
    int? unitCount,
    bool? atmPaid,
    num? selectedArea,
    bool? changingInfo,
    List<String>? issuingPredefinedConditions,
    List<LicensePermitEntity>? licensePermits,
    List<SupervisingAuthorityEntity>? supervisingAuthorities,
    List<String>? civilDefensePredefinedConditions,
    List<String>? cleaningMechanisms,
    List<CommercialOfficeEntity>? commercialOffices,
    MunicipalAdvisorEvent? lastEvent,
    String? errorMessage,
  }) {
    return MunicipalAdvisorState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      consultationKey: consultationKey ?? this.consultationKey,
      gisResponse: gisResponse ?? this.gisResponse,
      activityLocation: activityLocation ?? this.activityLocation,
      isicActivities: isicActivities ?? this.isicActivities,
      selectedIsicActivity: selectedIsicActivity ?? this.selectedIsicActivity,
      isicSubActivities: isicSubActivities ?? this.isicSubActivities,
      selectedIsicSubActivity:
          selectedIsicSubActivity ?? this.selectedIsicSubActivity,
      activityDetails: activityDetails ?? this.activityDetails,
      accommodationTypes: accommodationTypes ?? this.accommodationTypes,
      selectedAccommodationType:
          selectedAccommodationType ?? this.selectedAccommodationType,
      unitCount: unitCount ?? this.unitCount,
      atmPaid: atmPaid ?? this.atmPaid,
      selectedArea: selectedArea ?? this.selectedArea,
      changingInfo: changingInfo ?? this.changingInfo,
      issuingPredefinedConditions:
          issuingPredefinedConditions ?? this.issuingPredefinedConditions,
      licensePermits: licensePermits ?? this.licensePermits,
      supervisingAuthorities:
          supervisingAuthorities ?? this.supervisingAuthorities,
      civilDefensePredefinedConditions: civilDefensePredefinedConditions ??
          this.civilDefensePredefinedConditions,
      cleaningMechanisms: cleaningMechanisms ?? this.cleaningMechanisms,
      commercialOffices: commercialOffices ?? this.commercialOffices,
      lastEvent: lastEvent ?? this.lastEvent,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        consultationKey,
        gisResponse,
        activityLocation,
        isicActivities,
        selectedIsicActivity,
        isicSubActivities,
        selectedIsicSubActivity,
        activityDetails,
        accommodationTypes,
        selectedAccommodationType,
        unitCount,
        atmPaid,
        selectedArea,
        changingInfo,
        issuingPredefinedConditions,
        licensePermits,
        supervisingAuthorities,
        civilDefensePredefinedConditions,
        cleaningMechanisms,
        commercialOffices,
        lastEvent,
        errorMessage,
      ];
}
