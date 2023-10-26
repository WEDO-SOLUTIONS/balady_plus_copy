part of 'renew_commercial_license_bloc.dart';

class RenewCommercialLicenseState extends Equatable {
  final BlocStatus status;
  final BlocStatus contractsListStatus;
  final BlocRequestStatus renewYearsStatus;
  final BlocStatus requestDetailsStatus;

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

  const RenewCommercialLicenseState(
      {this.status = BlocStatus.initial,
      this.contractsListStatus = BlocStatus.initial,
      this.renewYearsStatus = BlocRequestStatus.initial,
      this.requestDetailsStatus = BlocStatus.initial,
      this.currentPageValue = 0,
      this.requestId,
      this.renewYears,
      this.licensePeriod,
      this.info,
      this.errorMessage,
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
      this.deedInfoRequst});

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
      ];

  RenewCommercialLicenseState copyWith(
      {BlocStatus? status,
      BlocStatus? requestDetailsStatus,
      BlocStatus? contractsListStatus,
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
      final String? salamaBillNumber,
      final String? salamaPermitNumber,
      final String? salamaReportNumber,
      CrAttachmentResponse? attachmentResponse,
      List<AttachmentData>? attachments,
      final RenewRequestDetails? renewRequestDetails,
      final DeedInfoRequest? deedInfoRequst}) {
    return RenewCommercialLicenseState(
        status: status ?? this.status,
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
        salamaBillNumber: salamaBillNumber ?? this.salamaBillNumber,
        salamaPermitNumber: salamaPermitNumber ?? this.salamaPermitNumber,
        salamaReportNumber: salamaReportNumber ?? this.salamaReportNumber,
        attachments: attachments ?? this.attachments,
        attachmentResponse: attachmentResponse ?? this.attachmentResponse,
        requestDetailsStatus: requestDetailsStatus ?? this.requestDetailsStatus,
        deedVerified:
            deedVerified == null ? this.deedVerified : deedVerified.value,
        deedInfoRequst: deedInfoRequst ?? this.deedInfoRequst);
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
}
