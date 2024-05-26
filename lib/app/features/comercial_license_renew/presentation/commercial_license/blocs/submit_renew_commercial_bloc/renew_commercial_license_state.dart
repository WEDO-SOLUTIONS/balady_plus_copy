part of 'renew_commercial_license_bloc.dart';

class RenewCommercialLicenseState extends Equatable {
  final BlocStatus status;
  final BlocStatus contractsListStatus;
  final BlocRequestStatus renewYearsStatus;
  final BlocStatus requestDetailsStatus;
  final BlocStatus calculateInfoRequestStatus;
  final int currentPageValue;
  final List<Widget> pagesList;
  final int? requestId;
  final List<int>? renewYears;
  final int? licensePeriod;
  final RenewRequestInfo? info;
  final String? errorMessage;

  final BlocStatus investmentListStatus;

  final String? contractDate;
  final String? contractNumber;
  final String? contractOption;
  final String? contractType;

  final String? ownershipType;

  final CRRenewCleanOption? crRenewCleanOption;
  final CRRenewCleanContract? crRenewCleanContract;

  final CRSubmitterType? crSubmitterType;
  final CRContractType? crContractType;
  final CRContractOption? crContractOption;

  final CleanContractsResponse? cleanContractsResponse;
  final CleanContractItem? selectedCleanContract;

  final CRContractCleanRenewOptions? crContractCleanRenewOptions;

  final InvestmentContractResponse? investmentContractResponse;
  final InvestmentContractItem? selectedInvestmentContract;
  final String? cleanContractEndDate;
  final EjarInfoRequest? ejarInfoRequst;
  final DeedInfoRequest? deedInfoRequst;

  final bool? ejarVerified;
  final bool? deedVerified;
  final String? investmentContractNumber;

  final String? salamaBillNumber;
  final String? salamaPermitNumber;
  final String? salamaReportNumber;

  final CrAttachmentResponse? attachmentResponse;
  final List<AttachmentData>? attachments;
  final RenewRequestDetails? renewRequestDetails;
  final bool? salamaExists;
  final bool? insidePetrolStation;
  final bool? disableInsidePetrolStation;

  Cr700Validation get deedOwnerIdValidator => deedInfoRequst?.ownerId == null
      ? Cr700Validation.pure()
      : Cr700Validation.dirty(value: deedInfoRequst?.ownerId);

  String? get deedOwnerIdValidatorErrorText =>
      deedOwnerIdValidator.error?.message != null
          ? (deedOwnerIdValidator.error?.message ?? "").tr()
          : null;

  const RenewCommercialLicenseState(
      {this.status = BlocStatus.initial,
      this.contractsListStatus = BlocStatus.initial,
      this.renewYearsStatus = BlocRequestStatus.initial,
      this.requestDetailsStatus = BlocStatus.initial,
      this.calculateInfoRequestStatus = BlocStatus.initial,
      this.currentPageValue = 0,
      this.requestId,
      this.renewYears,
      this.licensePeriod,
      this.info,
      this.errorMessage,
      this.salamaExists,
      this.pagesList = const [
        CommercialRenewStep1(),
        CommercialRenewStep2(),
        CommercialRenewStep3(),
      ],
      this.investmentListStatus = BlocStatus.initial,
      this.contractDate,
      this.contractNumber,
      this.contractOption,
      this.contractType,
      this.ownershipType,
      this.crSubmitterType,
      this.crContractType,
      this.crContractOption,
      this.cleanContractsResponse,
      this.selectedCleanContract,
      this.investmentContractResponse,
      this.selectedInvestmentContract,
      this.crRenewCleanOption,
      this.cleanContractEndDate,
      this.crRenewCleanContract,
      this.crContractCleanRenewOptions,
      this.ejarInfoRequst,
      this.ejarVerified,
      this.investmentContractNumber,
      this.salamaBillNumber,
      this.salamaPermitNumber,
      this.salamaReportNumber,
      this.attachmentResponse,
      this.attachments,
      this.renewRequestDetails,
      this.deedVerified,
      this.deedInfoRequst,
      this.insidePetrolStation,
      this.disableInsidePetrolStation});

  @override
  List<Object?> get props => [
        status,
        currentPageValue,
        pagesList,
        requestId,
        renewYears,
        info,
        licensePeriod,
        renewYearsStatus,
        errorMessage,
        investmentListStatus,
        contractDate,
        contractNumber,
        contractOption,
        contractType,
        ownershipType,
        crSubmitterType,
        crContractType,
        crContractOption,
        cleanContractsResponse,
        selectedCleanContract,
        investmentContractResponse,
        selectedInvestmentContract,
        crRenewCleanOption,
        cleanContractEndDate,
        crRenewCleanContract,
        crContractCleanRenewOptions,
        ejarInfoRequst,
        ejarVerified,
        investmentContractNumber,
        contractsListStatus,
        salamaBillNumber,
        salamaPermitNumber,
        salamaReportNumber,
        attachments,
        attachmentResponse,
        renewRequestDetails,
        requestDetailsStatus,
        deedVerified,
        deedInfoRequst,
        calculateInfoRequestStatus,
        salamaExists,
        insidePetrolStation,
        disableInsidePetrolStation
      ];

  RenewCommercialLicenseState copyWith(
      {BlocStatus? status,
      BlocStatus? requestDetailsStatus,
      BlocStatus? contractsListStatus,
      BlocStatus? calculateInfoRequestStatus,
      int? currentPageValue,
      List<Widget>? pagesList,
      int? requestId,
      List<int>? renewYears,
      int? licensePeriod,
      RenewRequestInfo? info,
      BlocRequestStatus? renewYearsStatus,
      String? errorMessage,
      BlocStatus? investmentListStatus,
      Nullable<String?>? cleanContractEndDate,
      Nullable<String?>? contractDate,
      Nullable<String?>? contractNumber,
      Nullable<String?>? contractOption,
      Nullable<String?>? contractType,
      Nullable<String?>? ownershipType,
      Nullable<CRSubmitterType?>? crSubmitterType,
      Nullable<CRContractType?>? crContractType,
      Nullable<CRContractOption?>? crContractOption,
      Nullable<CleanContractsResponse?>? cleanContractsResponse,
      Nullable<CleanContractItem?>? selectedCleanContract,
      InvestmentContractResponse? investmentContractResponse,
      Nullable<InvestmentContractItem?>? selectedInvestmentContract,
      Nullable<CRRenewCleanOption?>? crRenewCleanOption,
      Nullable<CRRenewCleanContract?>? crRenewCleanContract,
      Nullable<CRContractCleanRenewOptions?>? crContractCleanRenewOptions,
      Nullable<EjarInfoRequest?>? ejarInfoRequst,
      Nullable<bool?>? ejarVerified,
      Nullable<bool?>? deedVerified,
      Nullable<String?>? investmentContractNumber,
      Nullable<String?>? salamaBillNumber,
      Nullable<String?>? salamaPermitNumber,
      Nullable<String?>? salamaReportNumber,
      CrAttachmentResponse? attachmentResponse,
      List<AttachmentData>? attachments,
      final RenewRequestDetails? renewRequestDetails,
      final DeedInfoRequest? deedInfoRequst,
      final Nullable<bool?>? salamaExists,
      final bool? insidePetrolStation,
      final bool? disableInsidePetrolStation}) {
    return RenewCommercialLicenseState(
        status: status ?? this.status,
        calculateInfoRequestStatus:
            calculateInfoRequestStatus ?? this.calculateInfoRequestStatus,
        renewRequestDetails: renewRequestDetails ?? this.renewRequestDetails,
        contractsListStatus: contractsListStatus ?? this.contractsListStatus,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        pagesList: pagesList ?? this.pagesList,
        requestId: requestId ?? this.requestId,
        renewYears: renewYears ?? this.renewYears,
        licensePeriod: licensePeriod ?? this.licensePeriod,
        info: info ?? this.info,
        renewYearsStatus: renewYearsStatus ?? this.renewYearsStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        investmentListStatus: investmentListStatus ?? this.investmentListStatus,
        contractDate:
            contractDate == null ? this.contractDate : contractDate.value,
        contractNumber:
            contractNumber == null ? this.contractNumber : contractNumber.value,
        contractOption:
            contractOption == null ? this.contractOption : contractOption.value,
        contractType:
            contractType == null ? this.contractType : contractType.value,
        ownershipType:
            ownershipType == null ? this.ownershipType : ownershipType.value,
        crSubmitterType: crSubmitterType == null
            ? this.crSubmitterType
            : crSubmitterType.value,
        crContractType:
            crContractType == null ? this.crContractType : crContractType.value,
        crContractOption: crContractOption == null
            ? this.crContractOption
            : crContractOption.value,
        cleanContractsResponse: cleanContractsResponse == null
            ? this.cleanContractsResponse
            : cleanContractsResponse.value,
        selectedCleanContract: selectedCleanContract == null
            ? this.selectedCleanContract
            : selectedCleanContract.value,
        investmentContractResponse:
            investmentContractResponse ?? this.investmentContractResponse,
        selectedInvestmentContract: selectedInvestmentContract == null
            ? this.selectedInvestmentContract
            : selectedInvestmentContract.value,
        cleanContractEndDate: cleanContractEndDate == null
            ? this.cleanContractEndDate
            : cleanContractEndDate.value,
        crRenewCleanOption: crRenewCleanOption == null
            ? this.crRenewCleanOption
            : crRenewCleanOption.value,
        crRenewCleanContract: crRenewCleanContract == null
            ? this.crRenewCleanContract
            : crRenewCleanContract.value,
        crContractCleanRenewOptions: crContractCleanRenewOptions == null
            ? this.crContractCleanRenewOptions
            : crContractCleanRenewOptions.value,
        ejarInfoRequst:
            ejarInfoRequst == null ? this.ejarInfoRequst : ejarInfoRequst.value,
        ejarVerified:
            ejarVerified == null ? this.ejarVerified : ejarVerified.value,
        investmentContractNumber: investmentContractNumber == null
            ? this.investmentContractNumber
            : investmentContractNumber.value,
        salamaBillNumber: salamaBillNumber == null
            ? this.salamaBillNumber
            : salamaBillNumber.value,
        salamaPermitNumber: salamaPermitNumber == null
            ? this.salamaPermitNumber
            : salamaPermitNumber.value,
        salamaReportNumber: salamaReportNumber == null
            ? this.salamaReportNumber
            : salamaReportNumber.value,
        attachments: attachments ?? this.attachments,
        attachmentResponse: attachmentResponse ?? this.attachmentResponse,
        requestDetailsStatus: requestDetailsStatus ?? this.requestDetailsStatus,
        deedVerified:
            deedVerified == null ? this.deedVerified : deedVerified.value,
        deedInfoRequst: deedInfoRequst ?? this.deedInfoRequst,
        salamaExists:
            salamaExists == null ? this.salamaExists : salamaExists.value,
        insidePetrolStation: insidePetrolStation ?? this.insidePetrolStation,
        disableInsidePetrolStation:
            disableInsidePetrolStation ?? this.disableInsidePetrolStation);
  }

  bool showSalamaReport() {
    if ((info?.salamaResponseDto?.allowedDocuments?.contains("REPORT") ??
            false) &&
        (info?.salamaResponseDto?.salamaReportOptions?.contains("SERVICE") ??
            false)) return true;

    return false;
  }

  bool showSalamaBill() {
    if ((info?.salamaResponseDto?.allowedDocuments?.contains("BILL") ??
            false) &&
        (info?.salamaResponseDto?.salamaBillOptions?.contains("SERVICE") ??
            false)) return true;

    return false;
  }

  bool showSalamaPermit() {
    if ((info?.salamaResponseDto?.allowedDocuments?.contains("PERMIT") ??
            false) &&
        (info?.salamaResponseDto?.salamaPermitOptions?.contains("SERVICE") ??
            false)) return true;

    return false;
  }

  bool isOnlyPermit() {
    if (info?.salamaResponseDto?.allowedDocuments?.contains("PERMIT") == true &&
        info?.salamaResponseDto?.allowedDocuments?.length == 1) {
      return true;
    }

    return false;
  }

  bool showAttachDeed() {
    if ((info?.ownershipResponseDto?.contractOptionsResponseDto?.deedOptions
            ?.contains("ATTACH") ??
        false)) return true;

    return false;
  }

  bool showAttachEjar() {
    if ((info?.ownershipResponseDto?.contractOptionsResponseDto?.ejarOptions
            ?.contains("ATTACH") ??
        false)) return true;

    return false;
  }

  bool showAttachInvest() {
    if ((info?.ownershipResponseDto?.contractOptionsResponseDto?.investOptions
            ?.contains("ATTACH") ??
        false)) return true;

    return false;
  }

  bool showServicehDeed() {
    if ((info?.ownershipResponseDto?.contractOptionsResponseDto?.deedOptions
            ?.contains("SERVICE") ??
        false)) return true;

    return false;
  }

  bool showServiceEjar() {
    if ((info?.ownershipResponseDto?.contractOptionsResponseDto?.ejarOptions
            ?.contains("SERVICE") ??
        false)) return true;

    return false;
  }

  bool showServiceInvest() {
    if ((info?.ownershipResponseDto?.contractOptionsResponseDto?.investOptions
            ?.contains("SERVICE") ??
        false)) return true;

    return false;
  }

  bool cleanOptionBALADIASADAD() {
    return info?.cleanContractResponseDto?.cleanContractOptions?.cleanOption ==
        "BALADIA_SADAD";
  }

  bool cleanOptionCLEANCONTRACT() {
    return info?.cleanContractResponseDto?.cleanContractOptions?.cleanOption ==
        "CLEAN_CONTRACT";
  }

  bool cleanOptionOPTIONAL() {
    return info?.cleanContractResponseDto?.cleanContractOptions?.cleanOption ==
        "OPTIONAL";
  }

  bool cleanTypeAttach() {
    return info
            ?.cleanContractResponseDto?.cleanContractOptions?.contractOption ==
        "ATTACH";
  }

  bool cleanTypeService() {
    return info
            ?.cleanContractResponseDto?.cleanContractOptions?.contractOption ==
        "SERVICE";
  }

  bool cleanTypeATTACHSERVICE() {
    return info
            ?.cleanContractResponseDto?.cleanContractOptions?.contractOption ==
        "ATTACH,SERVICE";
  }

  bool cleanContractshowPayAll() {
    return cleanOptionBALADIASADAD() || cleanOptionOPTIONAL();
  }

  bool cleanContractshowAttach() {
    return (cleanTypeATTACHSERVICE() || cleanTypeAttach()) &
        !cleanOptionBALADIASADAD();
  }

  bool cleanContractshowService() {
    return (cleanTypeATTACHSERVICE() || cleanTypeService()) &
        !cleanOptionBALADIASADAD();
  }

  bool showDeedService() {
    return info?.ownershipResponseDto?.contractType == "DEED" &&
        info?.ownershipResponseDto?.contractOption == "SERVICE";
  }

  bool showEJARService() {
    return info?.ownershipResponseDto?.contractType == "EJAR" &&
        info?.ownershipResponseDto?.contractOption == "SERVICE";
  }

  bool showDeedAttach() {
    return info?.ownershipResponseDto?.contractType == "DEED" &&
        info?.ownershipResponseDto?.contractOption == "ATTACH";
  }

  bool showEJARAttach() {
    return info?.ownershipResponseDto?.contractType == "EJAR" &&
        info?.ownershipResponseDto?.contractOption == "ATTACH";
  }

  bool showINVESTService() {
    return info?.ownershipResponseDto?.contractType == "INVEST" &&
        info?.ownershipResponseDto?.contractOption == "SERVICE";
  }

  bool showINVESTAttach() {
    return info?.ownershipResponseDto?.contractType == "INVEST" &&
        info?.ownershipResponseDto?.contractOption == "ATTACH";
  }

  String getContractName() {
    switch (info?.ownershipResponseDto?.contractType) {
      case "EJAR":
        return "rent_contract".tr();
      case "INVEST":
        return "invest_contract_2".tr();
      case "DEED":
        return "deed_contract".tr();
    }
    return info?.ownershipResponseDto?.contractType ?? "";
  }

  bool showSalmaExists() {
    return showSalamaPermit() ||
        (showSalamaPermit() && (showSalamaReport() || showSalamaBill()));
  }

  bool isFormValid() {
    if (licensePeriod == null) return false;

    if (crSubmitterType == null) return false;

    if (insidePetrolStation == null) return false;

    if (crContractOption == CRContractOption.service &&
        crContractType == CRContractType.deed &&
        deedVerified == false) return false;

    if (crContractOption == CRContractOption.service &&
        crContractType == CRContractType.ejar &&
        ejarVerified == false) return false;


    // All Salma validation
    if (showSalmaExists() && salamaExists == null) return false;
    if ((showSalamaReport() && !showSalmaExists()) ||
        (showSalamaReport() && salamaExists == false) &&
            (salamaReportNumber?.isEmpty ?? true)) return false;
    if ((showSalamaBill() && !showSalmaExists()) ||
        (showSalamaBill() && salamaExists == false) &&
            (salamaBillNumber?.isEmpty ?? true)) return false;
    if ((showSalamaPermit() && !showSalmaExists()) ||
        (showSalamaPermit() && salamaExists == true) &&
            (salamaPermitNumber?.isEmpty ?? true)) return false;

    return true;
  }

  bool isAttacmentsFormValid() {
    bool isValid = true;

    attachments?.forEach((element) {
      if (element.isUploaded == false && element.isRequired == true) {
        isValid = false;
      }
    });
    return isValid;
  }

  String? getExitingContractNumber() =>
      info?.cleanContractResponseDto?.cleanContractInfo?.contractNumber;
}
