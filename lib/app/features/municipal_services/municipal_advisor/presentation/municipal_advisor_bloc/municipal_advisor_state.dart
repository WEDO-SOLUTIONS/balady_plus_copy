part of 'municipal_advisor_bloc.dart';

class MunicipalAdvisorState extends Equatable {
  final BlocRequestStatus status;
  final List<ChatMessage> messages;
  final MunicipalAdvisorSteps currentStep;
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
  final List<CleaningEntity> cleaningMechanisms;
  final List<CommercialOfficeEntity>? commercialOffices;
  final int maxYears;
  final ConditionsUrlsEntity? conditionsUrls;
  final List<FastflowConditionEntity> fastflowConditions;
  final List<int> licenseYears;
  final List<BoardTypeEntity> boardTypes;
  final int selectedLicenseYear;
  final List<BoardsParams> boards;
  final CleaningEntity? selectedCleanMechanism;
  final List<PermitsParams> selectedPermits;
  final LicenseFeesEntity? licenseFees;
  final SideWalkParamsModel sideWalkParams;
  final int nonFoodVehicleCount;
  final bool? hasBrand;
  final List<ContractEntity> shopOwnerships;
  final ContractEntity? selectedShopOwnership;
  final ContractOptionEntity? selectedShopContractOption;
  final List<AttachmentEntity> attachments;
  final List<RequestStepModel> requestFlow;
  final List<String> requestFlowRecommendations;
  final MunicipalAdvisorEvent? lastEvent;
  final String? errorMessage;

  const MunicipalAdvisorState({
    this.status = BlocRequestStatus.initial,
    this.messages = const <ChatMessage>[],
    this.currentStep = MunicipalAdvisorSteps.start,
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
    this.cleaningMechanisms = const <CleaningEntity>[],
    this.commercialOffices,
    this.maxYears = 0,
    this.conditionsUrls,
    this.fastflowConditions = const <FastflowConditionEntity>[],
    this.licenseYears = const <int>[],
    this.boardTypes = const <BoardTypeEntity>[],
    this.selectedLicenseYear = 1,
    this.boards = const <BoardsParams>[],
    this.selectedCleanMechanism,
    this.licenseFees,
    this.selectedPermits = const <PermitsParams>[],
    this.sideWalkParams = const SideWalkParamsModel(
      width: 1,
      length: 1,
      days: 1,
    ),
    this.nonFoodVehicleCount = 1,
    this.hasBrand,
    this.shopOwnerships = const <ContractEntity>[],
    this.selectedShopOwnership,
    this.selectedShopContractOption,
    this.attachments = const <AttachmentEntity>[],
    this.requestFlow = const <RequestStepModel>[],
    this.requestFlowRecommendations = const <String>[],
    this.lastEvent,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  bool get licenseCostFinishEnabled =>
      selectedCleanMechanism != null && boards.isNotEmpty;

  bool get attachmentsFinishEnabled =>
      hasBrand != null &&
      selectedShopOwnership != null &&
      selectedShopContractOption != null;

  num permitHours(PermitsFeesEntity permit) {
    final licensePermit = licensePermits?.firstWhere(
      (element) => element.permitTypeId == permit.actionTypeId,
    );
    return licensePermit?.cost ?? 0;
  }

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
    List<CleaningEntity>? cleaningMechanisms,
    List<CommercialOfficeEntity>? commercialOffices,
    int? maxYears,
    ConditionsUrlsEntity? conditionsUrls,
    List<FastflowConditionEntity>? fastflowConditions,
    List<int>? licenseYears,
    List<BoardTypeEntity>? boardTypes,
    int? selectedLicenseYear,
    List<BoardsParams>? boards,
    CleaningEntity? selectedCleanMechanism,
    LicenseFeesEntity? licenseFees,
    List<PermitsParams>? selectedPermits,
    SideWalkParamsModel? sideWalkParams,
    int? nonFoodVehicleCount,
    bool? hasBrand,
    List<ContractEntity>? shopOwnerships,
    ContractEntity? selectedShopOwnership,
    ContractOptionEntity? selectedShopContractOption,
    List<AttachmentEntity>? attachments,
    List<RequestStepModel>? requestFlow,
    List<String>? requestFlowRecommendations,
    MunicipalAdvisorEvent? lastEvent,
    String? errorMessage,
  }) {
    return MunicipalAdvisorState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      currentStep: messages?.isEmpty ?? this.messages.isEmpty
          ? MunicipalAdvisorSteps.start
          : messages?.last.step ?? this.messages.last.step,
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
      maxYears: maxYears ?? this.maxYears,
      conditionsUrls: conditionsUrls ?? this.conditionsUrls,
      fastflowConditions: fastflowConditions ?? this.fastflowConditions,
      licenseYears: licenseYears ?? this.licenseYears,
      boardTypes: boardTypes ?? this.boardTypes,
      selectedLicenseYear: selectedLicenseYear ?? this.selectedLicenseYear,
      boards: boards ?? this.boards,
      selectedCleanMechanism:
          selectedCleanMechanism ?? this.selectedCleanMechanism,
      licenseFees: licenseFees ?? this.licenseFees,
      selectedPermits: selectedPermits ?? this.selectedPermits,
      sideWalkParams: sideWalkParams ?? this.sideWalkParams,
      nonFoodVehicleCount: nonFoodVehicleCount ?? this.nonFoodVehicleCount,
      hasBrand: hasBrand ?? this.hasBrand,
      shopOwnerships: shopOwnerships ?? this.shopOwnerships,
      selectedShopOwnership:
          selectedShopOwnership ?? this.selectedShopOwnership,
      selectedShopContractOption:
          selectedShopContractOption ?? this.selectedShopContractOption,
      attachments: attachments ?? this.attachments,
      requestFlow: requestFlow ?? this.requestFlow,
      requestFlowRecommendations:
          requestFlowRecommendations ?? this.requestFlowRecommendations,
      lastEvent: lastEvent ?? this.lastEvent,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        currentStep,
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
        maxYears,
        conditionsUrls,
        fastflowConditions,
        licenseYears,
        boardTypes,
        selectedLicenseYear,
        boards,
        selectedCleanMechanism,
        licenseFees,
        selectedPermits,
        sideWalkParams,
        nonFoodVehicleCount,
        hasBrand,
        shopOwnerships,
        selectedShopOwnership,
        selectedShopContractOption,
        attachments,
        requestFlow,
        requestFlowRecommendations,
        lastEvent,
        errorMessage,
      ];
}
