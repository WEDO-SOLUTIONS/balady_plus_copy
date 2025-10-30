part of 'municipal_advisor_bloc.dart';

class MunicipalAdvisorState extends Equatable {
  final BlocRequestStatus status;
  final List<ChatMessage> messages;
  final MunicipalAdvisorSteps currentStep;
  final String? consultationKey;
  final GISResponse? gisResponse;
  final GISParams? location;
  final ActivityLocation? activityLocation;
  final List<IsicActivityEntity> isicActivities;
  final IsicActivityEntity? selectedIsicActivity;
  final List<IsicActivityEntity> isicSubActivities;
  final IsicActivityEntity? selectedIsicSubActivity;
  final List<ActivityDetailsEntity> additionalActivities;
  final List<ActivityDetailsEntity> selectedAdditionalActivities;
  final ActivityDetailsEntity? activityDetails;
  final List<AccommodationTypeEntity> accommodationTypes;
  final AccommodationTypeEntity? selectedAccommodationType;
  final int? unitCount;
  final bool? atmPaid;
  final bool? hasSalama;
  final List<CivilDefenceEntity>? civilDefenceList;
  final num? selectedArea;
  final num? totalShopArea;
  final bool changingInfo;
  final List<String> issuingPredefinedConditions;
  final List<LicensePermitEntity> licensePermits;
  final List<SupervisingAuthorityEntity> supervisingAuthorities;
  final List<String> civilDefensePredefinedConditions;
  final List<CleaningEntity> cleaningMechanisms;
  final List<CommercialOfficeEntity> commercialOffices;
  final List<EngineeringOfficeEntity> engineeringOffices;
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
  final List<BuildingComplianceEntity>? buildingComplince;
  final MunicipalAdvisorEvent? lastEvent;
  final int topic;
  final String? errorMessage;
  final int? id;

  const MunicipalAdvisorState(
      {this.status = BlocRequestStatus.initial,
      this.messages = const <ChatMessage>[],
      this.location,
      this.currentStep = MunicipalAdvisorSteps.start,
      this.consultationKey,
      this.gisResponse,
      this.topic = 0,
      this.activityLocation,
      this.isicActivities = const <IsicActivityEntity>[],
      this.selectedIsicActivity,
      this.isicSubActivities = const <IsicActivityEntity>[],
      this.selectedIsicSubActivity,
      this.additionalActivities = const <ActivityDetailsEntity>[],
      this.selectedAdditionalActivities = const <ActivityDetailsEntity>[],
      this.activityDetails,
      this.accommodationTypes = const <AccommodationTypeEntity>[],
      this.selectedAccommodationType,
      this.unitCount,
      this.atmPaid,
      this.hasSalama,
      this.civilDefenceList,
      this.selectedArea,
        this.totalShopArea,
      this.changingInfo = false,
      this.issuingPredefinedConditions = const <String>[],
      this.licensePermits = const <LicensePermitEntity>[],
      this.supervisingAuthorities = const <SupervisingAuthorityEntity>[],
      this.civilDefensePredefinedConditions = const <String>[],
      this.cleaningMechanisms = const <CleaningEntity>[],
      this.commercialOffices = const <CommercialOfficeEntity>[],
      this.engineeringOffices = const <EngineeringOfficeEntity>[],
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
      this.buildingComplince,
      this.errorMessage,
      this.id});

  String get error => errorMessage ?? '';

  bool get licenseCostFinishEnabled =>
      selectedCleanMechanism != null && boards.isNotEmpty;

  bool get attachmentsFinishEnabled =>
      hasBrand != null &&
      selectedShopOwnership != null &&
      selectedShopContractOption != null;

  num permitHours(PermitsFeesEntity permit) {
    final licensePermit = licensePermits.firstWhere(
      (element) => element.permitTypeId == permit.actionTypeId,
    );
    return licensePermit.cost;
  }

  MunicipalAdvisorState copyWith({
    BlocRequestStatus? status,
    GISParams? location,
    int? topic,
    List<ChatMessage>? messages,
    String? consultationKey,
    GISResponse? gisResponse,
    ActivityLocation? activityLocation,
    List<IsicActivityEntity>? isicActivities,
    IsicActivityEntity? selectedIsicActivity,
    List<IsicActivityEntity>? isicSubActivities,
    IsicActivityEntity? selectedIsicSubActivity,
    List<ActivityDetailsEntity>? additionalActivities,
    List<ActivityDetailsEntity>? selectedAdditionalActivities,
    ActivityDetailsEntity? activityDetails,
    List<AccommodationTypeEntity>? accommodationTypes,
    AccommodationTypeEntity? selectedAccommodationType,
    int? unitCount,
    bool? atmPaid,
    Nullable<bool?>? hasSalama,
    List<CivilDefenceEntity>? civilDefenceList,
    num? selectedArea,
    num? totalShopArea,
    bool? changingInfo,
    List<String>? issuingPredefinedConditions,
    List<LicensePermitEntity>? licensePermits,
    List<SupervisingAuthorityEntity>? supervisingAuthorities,
    List<String>? civilDefensePredefinedConditions,
    List<CleaningEntity>? cleaningMechanisms,
    List<CommercialOfficeEntity>? commercialOffices,
    List<EngineeringOfficeEntity>? engineeringOffices,
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
    List<BuildingComplianceEntity>? buildingComplince,
    MunicipalAdvisorEvent? lastEvent,
    String? errorMessage,
    int? id,
  }) {
    return MunicipalAdvisorState(
        topic: topic ?? this.topic,
        status: status ?? this.status,
        messages: messages ?? this.messages,
        currentStep: messages?.isEmpty ?? this.messages.isEmpty
            ? MunicipalAdvisorSteps.start
            : messages?.last.step ?? this.messages.last.step,
        consultationKey: consultationKey ?? this.consultationKey,
        gisResponse: gisResponse ?? this.gisResponse,
        location: location ?? this.location,
        activityLocation: activityLocation ?? this.activityLocation,
        isicActivities: isicActivities ?? this.isicActivities,
        selectedIsicActivity: selectedIsicActivity ?? this.selectedIsicActivity,
        isicSubActivities: isicSubActivities ?? this.isicSubActivities,
        selectedIsicSubActivity:
            selectedIsicSubActivity ?? this.selectedIsicSubActivity,
        additionalActivities: additionalActivities ?? this.additionalActivities,
        selectedAdditionalActivities:
            selectedAdditionalActivities ?? this.selectedAdditionalActivities,
        activityDetails: activityDetails ?? this.activityDetails,
        accommodationTypes: accommodationTypes ?? this.accommodationTypes,
        selectedAccommodationType:
            selectedAccommodationType ?? this.selectedAccommodationType,
        unitCount: unitCount ?? this.unitCount,
        atmPaid: atmPaid ?? this.atmPaid,
        hasSalama: hasSalama == null ? this.hasSalama : hasSalama.value,
        civilDefenceList: civilDefenceList ?? this.civilDefenceList,
        selectedArea: selectedArea ?? this.selectedArea,
        totalShopArea: totalShopArea ?? this.totalShopArea,
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
        engineeringOffices: engineeringOffices ?? this.engineeringOffices,
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
        buildingComplince: buildingComplince ?? this.buildingComplince,
        requestFlowRecommendations:
            requestFlowRecommendations ?? this.requestFlowRecommendations,
        lastEvent: lastEvent ?? this.lastEvent,
        errorMessage: errorMessage ?? this.errorMessage,
        id: id ?? this.id);
  }

  @override
  List<Object?> get props => [
        status,
        topic,
        messages,
        currentStep,
        consultationKey,
        gisResponse,
        activityLocation,
        isicActivities,
        selectedIsicActivity,
        isicSubActivities,
        selectedIsicSubActivity,
        additionalActivities,
        selectedAdditionalActivities,
        activityDetails,
        accommodationTypes,
        selectedAccommodationType,
        unitCount,
        atmPaid,
        hasSalama,
        selectedArea,
        totalShopArea,
        changingInfo,
        issuingPredefinedConditions,
        licensePermits,
        supervisingAuthorities,
        civilDefensePredefinedConditions,
        cleaningMechanisms,
        commercialOffices,
        engineeringOffices,
        maxYears,
        conditionsUrls,
        fastflowConditions,
        licenseYears,
        boardTypes,
        selectedLicenseYear,
        boards,
        selectedCleanMechanism,
        location,
        selectedPermits,
        licenseFees,
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
        buildingComplince,
        errorMessage,
        id
      ];
}
