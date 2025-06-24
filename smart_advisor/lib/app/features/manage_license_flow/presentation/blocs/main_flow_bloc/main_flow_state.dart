part of 'main_flow_bloc.dart';

class ManageMainFlowState extends Equatable {
  final BlocStatus delegatorsStatus;

  final GISDataRequest? request;

  final String? errorMessage;

  final BlocStatus status;

  final int currentPages;
  final GisDataResponse? gisResponse;

  final String? atmOption;

  final int? editSelection;
  final int? step1Selection;
  final int? step1User;
  final int actionNumber;
  final bool? isLastRenewPage;
  final bool? isLastEditPage;
  final bool? isLastCancelPage;
  final bool? isLastTransfarPage;
  int? step2Selection;
  final List<DelegatorEntity>? delegators;
  final DelegatorEntity? selectedDelegator;
  final List<LicensesResponseItem>? licenses;
  final LicensesResponseItem? selectedLicense;
  final BlocStatus licenseStatus;
  final BlocStatus licenseDetailsStatus;

  final LicenseDetails? selectedLicenseDetails;

  final RegulationResponse? regulationResponse;
  final BlocStatus regulationStatus;
  final String? regulationErrorMsg;

  final EntityActivityDetailsResponse? entityActivityDetailsResponse;
  final BlocStatus entityActivityDetailsStatus;
  final String? entityActivityDetailsErrorMsg;

  final List<EntityViolationActivityModel>? violations;
  final BlocStatus violationStatus;
  final BlocStatus violationDetailsStatus;
  final List<ViolationDetailsVdModel>? vdViolationList;
  final BlocStatus vdViolationStatus;

  final BlocStatus activityDetailsStatus;
  LookUpItem? selectedActivity;
  List<AddetionalActivityItem>? addetainalActivites;
  List<AddetionalActivityItem>? selectedAddetainalActivites;
  List<int>? selectedTransferPermits;
  final String? newCRNumber;

  ManageMainFlowState(
      {this.step1Selection,
      this.step2Selection = 0,
      this.editSelection,
      this.step1User,
      this.isLastRenewPage = false,
      this.isLastEditPage = false,
      this.isLastCancelPage = false,
      this.isLastTransfarPage = false,
      this.actionNumber = 0,
      this.errorMessage,
      this.status = BlocStatus.initial,
      this.currentPages = 0,
      this.request,
      this.gisResponse,
      this.atmOption,
      this.delegators = const [],
      this.delegatorsStatus = BlocStatus.initial,
      this.selectedDelegator,
      this.licenses = const [],
      this.licenseStatus = BlocStatus.initial,
      this.selectedLicense,
      this.selectedLicenseDetails,
      this.licenseDetailsStatus = BlocStatus.initial,
      this.regulationResponse,
      this.regulationStatus = BlocStatus.initial,
      this.regulationErrorMsg,
      this.entityActivityDetailsResponse,
      this.entityActivityDetailsStatus = BlocStatus.initial,
      this.violationDetailsStatus = BlocStatus.initial,
      this.violationStatus = BlocStatus.initial,
      this.vdViolationStatus = BlocStatus.initial,
      this.vdViolationList,
      this.violations,
      this.entityActivityDetailsErrorMsg,
      this.activityDetailsStatus = BlocStatus.initial,
      this.selectedActivity,
      this.addetainalActivites,
      this.selectedAddetainalActivites,
      this.selectedTransferPermits,
      this.newCRNumber});

  @override
  List<Object?> get props => [
        // activityDetailsStatus,
        // categoryCount,
        delegators,
        isLastRenewPage,
        isLastEditPage,
        isLastCancelPage,
        isLastTransfarPage,
        editSelection,
        actionNumber,
        step1Selection,
        atmOption,
        errorMessage,
        status,
        currentPages,
        gisResponse,
        request,
        delegatorsStatus,
        selectedDelegator,
        licenses,
        licenseStatus,
        selectedLicense,
        selectedLicenseDetails,
        licenseDetailsStatus,
        violationDetailsStatus,
        regulationResponse,
        regulationStatus,
        regulationErrorMsg,
        entityActivityDetailsResponse,
        entityActivityDetailsStatus,
        entityActivityDetailsErrorMsg,
        violationStatus,
        vdViolationList,
        vdViolationStatus,
        activityDetailsStatus,
        selectedActivity,
        addetainalActivites,
        selectedAddetainalActivites,
        selectedTransferPermits, newCRNumber
      ];

  ManageMainFlowState copyWith(
      {final int? step1Selection,
      final int? step1User,
      final int? editSelection,
      final int? actionNumber,
      final String? atmOption,
      final bool? isLastRenewPage,
      final bool? isLastEditPage,
      final bool? isLastCancelPage,
      final bool? isLastTransfarPage,
      String? errorMessage,
      BlocStatus? status,
      int? currentPages,
      GISDataRequest? request,
      GisDataResponse? gisResponse,
      List<DelegatorEntity>? delegators,
      BlocStatus? delegatorsStatus,
      DelegatorEntity? selectedDelegator,
      List<LicensesResponseItem>? licenses,
      BlocStatus? licenseStatus,
      LicensesResponseItem? selectedLicense,
      LicenseDetails? selectedLicenseDetails,
      BlocStatus? licenseDetailsStatus,
      RegulationResponse? regulationResponse,
      BlocStatus? regulationStatus,
      BlocStatus? violationDetailsStatus,
      String? regulationErrorMsg,
      final EntityActivityDetailsResponse? entityActivityDetailsResponse,
      final BlocStatus? entityActivityDetailsStatus,
      final String? entityActivityDetailsErrorMsg,
      final BlocStatus? violationStatus,
      final List<EntityViolationActivityModel>? violations,
      final List<ViolationDetailsVdModel>? vdViolationList,
      final BlocStatus? vdViolationStatus,
      final BlocStatus? activityDetailsStatus,
      final LookUpItem? selectedActivity,
      final List<AddetionalActivityItem>? addetainalActivites,
      List<AddetionalActivityItem>? selectedAddetainalActivites,
      List<int>? selectedTransferPermits,
      final bool? clearLicense,
      final bool? clearDelegate,
      final String? newCRNumber}) {
    return ManageMainFlowState(
        selectedAddetainalActivites:
            selectedAddetainalActivites ?? this.selectedAddetainalActivites,
        isLastTransfarPage: isLastTransfarPage ?? this.isLastTransfarPage,
        isLastCancelPage: isLastCancelPage ?? this.isLastCancelPage,
        isLastEditPage: isLastEditPage ?? this.isLastEditPage,
        isLastRenewPage: isLastRenewPage ?? this.isLastRenewPage,
        step1Selection: step1Selection ?? this.step1Selection,
        step1User: step1User ?? this.step1User,
        editSelection: editSelection ?? this.editSelection,
        actionNumber: actionNumber ?? this.actionNumber,
        atmOption: atmOption ?? this.atmOption,
        request: request ?? this.request,
        gisResponse: gisResponse ?? this.gisResponse,
        currentPages: currentPages ?? this.currentPages,
        errorMessage: errorMessage,
        status: status ?? this.status,
        delegators: delegators ?? this.delegators,
        delegatorsStatus: delegatorsStatus ?? this.delegatorsStatus,
        selectedDelegator: clearDelegate == true
            ? null
            : selectedDelegator ?? this.selectedDelegator,
        licenses: clearDelegate == true ? null : licenses ?? this.licenses,
        licenseStatus: licenseStatus ?? this.licenseStatus,
        selectedLicense: clearLicense == true
            ? null
            : selectedLicense ?? this.selectedLicense,
        selectedLicenseDetails: clearLicense == true
            ? null
            : selectedLicenseDetails ?? this.selectedLicenseDetails,
        licenseDetailsStatus: licenseDetailsStatus ?? this.licenseDetailsStatus,
        vdViolationList: clearLicense == true
            ? null
            : vdViolationList ?? this.vdViolationList,
        vdViolationStatus: vdViolationStatus ?? this.vdViolationStatus,
        violationStatus: violationStatus ?? this.violationStatus,
        violationDetailsStatus:
            violationDetailsStatus ?? this.violationDetailsStatus,
        regulationResponse: clearLicense == true
            ? null
            : regulationResponse ?? this.regulationResponse,
        regulationStatus: regulationStatus ?? this.regulationStatus,
        regulationErrorMsg: regulationErrorMsg ?? this.regulationErrorMsg,
        entityActivityDetailsResponse:
            entityActivityDetailsResponse ?? this.entityActivityDetailsResponse,
        entityActivityDetailsStatus:
            entityActivityDetailsStatus ?? this.entityActivityDetailsStatus,
        entityActivityDetailsErrorMsg:
            entityActivityDetailsErrorMsg ?? this.entityActivityDetailsErrorMsg,
        violations: clearLicense == true ? null : violations ?? this.violations,
        activityDetailsStatus:
            activityDetailsStatus ?? this.activityDetailsStatus,
        selectedActivity: clearLicense == true
            ? null
            : selectedActivity ?? this.selectedActivity,
        addetainalActivites: clearLicense == true
            ? null
            : addetainalActivites ?? this.addetainalActivites,
        selectedTransferPermits:
            selectedTransferPermits ?? this.selectedTransferPermits,
        newCRNumber: newCRNumber ?? this.newCRNumber);
  }

  bool isNextDisabled() {
    if (currentPages == 0 && actionNumber == 0) return true;
    if (step1User == 1 &&
        currentPages == 1 &&
        (actionNumber == 1 ||
            actionNumber == 2 ||
            actionNumber == 3 ||
            actionNumber == 4) &&
        selectedDelegator == null) return true;
    if (step1User == 1 &&
        (actionNumber == 1 ||
            actionNumber == 2 ||
            actionNumber == 3 ||
            actionNumber == 4) &&
        currentPages == 2 &&
        selectedLicense == null) return true;

    if (step1User == 1 &&
        (actionNumber == 4) &&
        currentPages == 4 &&
        (newCRNumber?.isEmpty ?? true)) return true;

    return false;
  }

  Map<String, List<EntityViolationActivityModel>> getViolations() {
    Map<String, List<EntityViolationActivityModel>> maps = {};

    violations?.forEach((element) {
      if (maps.containsKey(element.regulationName)) {
        List<EntityViolationActivityModel> list =
            maps[element.regulationName] ?? [];
        list.add(element);
        maps[element.regulationName ?? ""] = list;
      } else {
        List<EntityViolationActivityModel> list = [];
        list.add(element);
        maps[element.regulationName ?? ""] = list;
      }
    });
    print("FDDD ${maps.keys}");
    return maps;
  }

  List<String> getSubClauses() {
    return vdViolationList
            ?.map((e) => e.subClauseName)
            .nonNulls
            .toSet()
            .toList() ??
        [];
  }
}
