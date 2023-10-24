part of 'renew_commercial_license_bloc.dart';

class RenewCommercialLicenseState extends Equatable {
  final BlocStatus status;
  final BlocRequestStatus renewYearsStatus;
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

  final CRContractCleanRenewOptions? crContractCleanRenewOptions;

  final CRSubmitterType? crSubmitterType;
  final CRContractType? crContractType;
  final CRContractOption? crContractOption;

  final CleanContractsResponse? cleanContractsResponse;
  final CleanContractItem? selectedCleanContract;

  final InvestmentContractResponse? investmentContractResponse;
  final InvestmentContractItem? selectedInvestmentContract;
  final String? cleanContractEndDate;
  const RenewCommercialLicenseState(
      {this.status = BlocStatus.initial,
      this.renewYearsStatus = BlocRequestStatus.initial,
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
      this.crContractCleanRenewOptions,
      this.cleanContractEndDate});

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
        crContractCleanRenewOptions,
        cleanContractEndDate
      ];

  RenewCommercialLicenseState copyWith(
      {BlocStatus? status,
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
      Nullable<CRContractCleanRenewOptions?>? crContractCleanRenewOptions}) {
    return RenewCommercialLicenseState(
        status: status ?? this.status,
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
            contractDate == null ? this.contractDate : this.contractDate,
        contractNumber:
            contractNumber == null ? this.contractNumber : this.contractNumber,
        contractOption:
            contractOption == null ? this.contractOption : this.contractOption,
        contractType:
            contractType == null ? this.contractType : this.contractType,
        ownershipType:
            ownershipType == null ? this.ownershipType : this.ownershipType,
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
        crContractCleanRenewOptions: crContractCleanRenewOptions == null
            ? this.crContractCleanRenewOptions
            : crContractCleanRenewOptions.value);
  }
}
