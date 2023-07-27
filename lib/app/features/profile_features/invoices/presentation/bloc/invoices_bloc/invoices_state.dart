part of 'invoices_bloc.dart';

class InvoicesState extends Equatable {
  final BlocRequestStatus invoicesStatus;
  final List<InvoiceEntity> invoices;
  //invoice types
  final BlocRequestStatus invoiceTypesStatus;
  final List<InvoiceTypeEntity> invoiceTypes;
  final InvoiceTypeEntity? selectedInvoiceType;
  //invoice sub types
  final BlocRequestStatus invoiceSubTypesStatus;
  final List<InvoiceSubTypeEntity> invoiceSubTypes;
  final InvoiceSubTypeEntity? selectedInvoiceSubType;
  //invoice statuses
  final BlocRequestStatus invoiceStatusesStatus;
  final List<InvoiceStatusEntity> invoiceStatuses;
  final InvoiceStatusEntity? selectedInvoiceStatus;
  // invoice Date
  final DateTime? selectedInvoiceDueDate;
  final DateTime? selectedInvoiceIssueDate;
  // invoice number query
  final String? invoiceNumberQuery;
  final String? requestNumberQuery;
  //sort type
  final SortType sortType;

  // Date Form
  final DateForm? dateFormForIssue;

  // Date Form
  final DateForm? dateFormForDueDate;

  //error message
  final String? errorMessage;
  // pagination
  final int page;
  final int limit;
  final bool noMoreData;

  const InvoicesState({
    this.invoicesStatus = BlocRequestStatus.initial,
    this.invoices = const [],
    this.invoiceTypesStatus = BlocRequestStatus.initial,
    this.invoiceTypes = const [],
    this.selectedInvoiceType,
    this.invoiceSubTypesStatus = BlocRequestStatus.initial,
    this.invoiceSubTypes = const [],
    this.selectedInvoiceSubType,
    this.invoiceStatusesStatus = BlocRequestStatus.initial,
    this.invoiceStatuses = const [],
    this.selectedInvoiceStatus,
    this.selectedInvoiceDueDate,
    this.selectedInvoiceIssueDate,
    this.invoiceNumberQuery,
    this.requestNumberQuery,
    this.sortType = SortType.desc,
    this.errorMessage,
    this.page = 0,
    this.dateFormForIssue,
    this.dateFormForDueDate,
    this.limit = PaginationConstants.limit,
    this.noMoreData = false,
  });

  String get error => errorMessage ?? '';
  bool get paginationLoading =>
      invoicesStatus == BlocRequestStatus.submissionGetLoading && page > 0;

  InvoicesState copyWith({
    BlocRequestStatus? invoicesStatus,
    List<InvoiceEntity>? invoices,
    BlocRequestStatus? invoiceStatusesStatus,
    List<InvoiceStatusEntity>? invoiceStatuses,
    Nullable<InvoiceStatusEntity?>? selectedInvoiceStatus,
    BlocRequestStatus? invoiceTypesStatus,
    List<InvoiceTypeEntity>? invoiceTypes,
    Nullable<InvoiceTypeEntity?>? selectedInvoiceType,
    BlocRequestStatus? invoiceSubTypesStatus,
    List<InvoiceSubTypeEntity>? invoiceSubTypes,
    Nullable<InvoiceSubTypeEntity?>? selectedInvoiceSubType,
    Nullable<DateTime?>? selectedInvoiceDueDate,
    Nullable<DateTime?>? selectedInvoiceIssueDate,
    Nullable<String?>? invoiceNumberQuery,
    Nullable<String?>? requestNumberQuery,
    SortType? sortType,
    Nullable<DateForm?>? dateFormForIssue,
    Nullable<DateForm?>? dateFormForDueDate,
    String? errorMessage,
    int? page,
    int? limit,
    bool? noMoreData,
  }) =>
      InvoicesState(
        invoicesStatus: invoicesStatus ?? this.invoicesStatus,
        invoices: invoices ?? this.invoices,
        invoiceStatusesStatus:
            invoiceStatusesStatus ?? this.invoiceStatusesStatus,
        invoiceStatuses: invoiceStatuses ?? this.invoiceStatuses,
        selectedInvoiceStatus: selectedInvoiceStatus == null
            ? this.selectedInvoiceStatus
            : selectedInvoiceStatus.value,
        invoiceTypesStatus: invoiceTypesStatus ?? this.invoiceTypesStatus,
        invoiceTypes: invoiceTypes ?? this.invoiceTypes,
        selectedInvoiceType: selectedInvoiceType == null
            ? this.selectedInvoiceType
            : selectedInvoiceType.value,
        invoiceSubTypesStatus:
            invoiceSubTypesStatus ?? this.invoiceSubTypesStatus,
        invoiceSubTypes: invoiceSubTypes ?? this.invoiceSubTypes,
        selectedInvoiceSubType: selectedInvoiceSubType == null
            ? this.selectedInvoiceSubType
            : selectedInvoiceSubType.value,
        selectedInvoiceDueDate: selectedInvoiceDueDate == null
            ? this.selectedInvoiceDueDate
            : selectedInvoiceDueDate.value,
        selectedInvoiceIssueDate: selectedInvoiceIssueDate == null
            ? this.selectedInvoiceIssueDate
            : selectedInvoiceIssueDate.value,
        invoiceNumberQuery: invoiceNumberQuery == null
            ? this.invoiceNumberQuery
            : invoiceNumberQuery.value,
        requestNumberQuery: requestNumberQuery == null
            ? this.requestNumberQuery
            : requestNumberQuery.value,
        sortType: sortType ?? this.sortType,
        dateFormForIssue: dateFormForIssue == null
            ? this.dateFormForIssue
            : dateFormForIssue.value,
        dateFormForDueDate: dateFormForDueDate == null
            ? this.dateFormForDueDate
            : dateFormForDueDate.value,
        errorMessage: errorMessage,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        noMoreData: noMoreData ?? this.noMoreData,
      );

  @override
  List<Object?> get props => [
        invoicesStatus,
        invoices,
        invoiceTypesStatus,
        invoiceTypes,
        selectedInvoiceType,
        invoiceSubTypesStatus,
        invoiceSubTypes,
        selectedInvoiceSubType,
        invoiceStatusesStatus,
        invoiceStatuses,
        selectedInvoiceStatus,
        selectedInvoiceDueDate,
        selectedInvoiceIssueDate,
        invoiceNumberQuery,
        requestNumberQuery,
        sortType,
        errorMessage,
        dateFormForDueDate,
        dateFormForIssue,
        page,
        limit,
        noMoreData,
      ];
}
