part of 'violations_bloc.dart';

class ViolationsState extends Equatable {
  final BlocRequestStatus detailsStatus;

  final BlocRequestStatus violationsStatus;
  final List<ViolationsEntity> violations;
  // violations statuses
  final BlocRequestStatus violationsStatusesStatus;
  final List<ViolationsStatusEntity> violationsStatuses;
  final ViolationsStatusEntity? selectedViolationStatus;
  //Invoice statues
  final BlocRequestStatus invoiceStatusesStatus;
  final List<InvoiceStatusesEntity> invoiceStatuses;
  final InvoiceStatusesEntity? selectedInvoiceStatus;
  // Dates
  final DateTime? selectedObjectionLastApplyDate;
  final DateTime? selectedViolationIssueDate;
  // request number query
  final String? invoiceNumberQuery;
  final String? licenseNumberQuery;

  //sort type
  final SortType sortType;
  // Date Form
  final DateForm? lastDateForm;
  final DateForm? issueDateForm;
  //error message
  final String? errorMessage;

  // pagination
  final int page;
  final int limit;
  final bool noMoreData;

  const ViolationsState({
    this.violationsStatus = BlocRequestStatus.initial,
    this.detailsStatus = BlocRequestStatus.initial,
    this.violations = const [],
    this.violationsStatusesStatus = BlocRequestStatus.initial,
    this.violationsStatuses = const [],
    this.selectedViolationStatus,
    this.invoiceStatusesStatus = BlocRequestStatus.initial,
    this.invoiceStatuses = const [],
    this.selectedInvoiceStatus,
    this.selectedObjectionLastApplyDate,
    this.selectedViolationIssueDate,
    this.lastDateForm,
    this.issueDateForm,
    this.invoiceNumberQuery,
    this.licenseNumberQuery,
    this.sortType = SortType.desc,
    this.errorMessage,
    this.page = 0,
    this.limit = PaginationConstants.limit,
    this.noMoreData = false,
  });

  String get error => errorMessage ?? '';
  bool get paginationLoading =>
      violationsStatus == BlocRequestStatus.submissionGetLoading && page > 0;

  ViolationsState copyWith({
    BlocRequestStatus? detailsStatus,
    BlocRequestStatus? violationsStatus,
    List<ViolationsEntity>? violations,
    List<ViolationsStatusEntity>? violationsStatuses,
    Nullable<ViolationsStatusEntity?>? selectedViolationStatus,
    BlocRequestStatus? municipalitiesStatus,
    BlocRequestStatus? invoiceStatusesStatus,
    List<InvoiceStatusesEntity>? invoiceStatuses,
    Nullable<InvoiceStatusesEntity?>? selectedInvoiceStatus,
    BlocRequestStatus? requestSubTypesStatus,
    Nullable<DateTime?>? selectedObjectionLastApplyDate,
    Nullable<DateTime?>? selectedViolationIssueDate,
    Nullable<DateForm?>? lastDateForm,
    Nullable<DateForm?>? issueDateForm,
    Nullable<String?>? invoiceNumberQuery,
    Nullable<String?>? licenseNumberQuery,
    SortType? sortType,
    String? errorMessage,
    int? page,
    int? limit,
    bool? noMoreData,
  }) {
    return ViolationsState(
        violationsStatus: violationsStatus ?? this.violationsStatus,
        violations: violations ?? this.violations,
        violationsStatuses: violationsStatuses ?? this.violationsStatuses,
        selectedViolationStatus: selectedViolationStatus == null
            ? this.selectedViolationStatus
            : selectedViolationStatus.value,
        invoiceStatusesStatus:
            invoiceStatusesStatus ?? this.invoiceStatusesStatus,
        invoiceStatuses: invoiceStatuses ?? this.invoiceStatuses,
        selectedInvoiceStatus: selectedInvoiceStatus == null
            ? this.selectedInvoiceStatus
            : selectedInvoiceStatus.value,
        selectedObjectionLastApplyDate: selectedObjectionLastApplyDate == null
            ? this.selectedObjectionLastApplyDate
            : selectedObjectionLastApplyDate.value,
        selectedViolationIssueDate: selectedViolationIssueDate == null
            ? this.selectedViolationIssueDate
            : selectedViolationIssueDate.value,
        lastDateForm:
            lastDateForm == null ? this.lastDateForm : lastDateForm.value,
        issueDateForm:
            issueDateForm == null ? this.issueDateForm : issueDateForm.value,
        invoiceNumberQuery: invoiceNumberQuery == null
            ? this.invoiceNumberQuery
            : invoiceNumberQuery.value,
        licenseNumberQuery: licenseNumberQuery == null
            ? this.licenseNumberQuery
            : licenseNumberQuery.value,
        sortType: sortType ?? this.sortType,
        errorMessage: errorMessage ?? this.errorMessage,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        noMoreData: noMoreData ?? this.noMoreData,
        detailsStatus: detailsStatus ?? this.detailsStatus);
  }

  @override
  List<Object?> get props => [
        violationsStatus,
        violations,
        violationsStatusesStatus,
        violationsStatuses,
        selectedViolationStatus,
        selectedViolationIssueDate,
        invoiceStatusesStatus,
        invoiceStatuses,
        selectedInvoiceStatus,
        selectedObjectionLastApplyDate,
        lastDateForm,
        issueDateForm,
        invoiceNumberQuery,
        licenseNumberQuery,
        sortType,
        errorMessage,
        page,
        limit,
        noMoreData,
        detailsStatus
      ];
}
