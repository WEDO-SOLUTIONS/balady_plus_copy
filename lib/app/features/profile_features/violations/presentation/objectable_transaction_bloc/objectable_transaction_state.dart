part of 'objectable_transaction_bloc.dart';

class ObjectableTransactionState extends Equatable {
  final BlocRequestStatus detailsStatus;

  final BlocRequestStatus requestsStatus;
  final List<ObjectableTransactionsEntity> requests;
  //request statuses
  final BlocRequestStatus requestStatusesStatus;
  final List<RequestStatusEntity> requestStatuses;
  final RequestStatusEntity? selectedRequestStatus;
  //request types
  final BlocRequestStatus requestTypesStatus;
  final List<RequestTypeEntity> requestTypes;
  final RequestTypeEntity? selectedRequestType;
  //request sub types
  final BlocRequestStatus requestSubTypesStatus;
  final List<RequestSubTypeEntity> requestSubTypes;
  final RequestSubTypeEntity? selectedRequestSubType;
  // request Date
  final DateTime? selectedRequestDate;
  // request number query
  final String? requestNumberQuery;
  //sort type
  final SortType sortType;
  // Date Form
  final DateForm? dateForm;
  //error message
  final String? errorMessage;

  // pagination
  final int page;
  final int limit;
  final bool noMoreData;

  const ObjectableTransactionState({
    this.requestsStatus = BlocRequestStatus.initial,
    this.detailsStatus = BlocRequestStatus.initial,
    this.requests = const [],
    this.requestStatusesStatus = BlocRequestStatus.initial,
    this.requestStatuses = const [],
    this.selectedRequestStatus,
    this.requestTypesStatus = BlocRequestStatus.initial,
    this.requestTypes = const [],
    this.selectedRequestType,
    this.requestSubTypesStatus = BlocRequestStatus.initial,
    this.requestSubTypes = const [],
    this.selectedRequestSubType,
    this.selectedRequestDate,
    this.dateForm,
    this.requestNumberQuery,
    this.sortType = SortType.desc,
    this.errorMessage,
    this.page = 0,
    this.limit = PaginationConstants.limit,
    this.noMoreData = false,
  });

  String get error => errorMessage ?? '';
  bool get paginationLoading =>
      requestsStatus == BlocRequestStatus.submissionGetLoading && page > 0;

  ObjectableTransactionState copyWith({
    BlocRequestStatus? detailsStatus,
    BlocRequestStatus? requestsStatus,
    List<ObjectableTransactionsEntity>? requests,
    BlocRequestStatus? requestStatusesStatus,
    List<RequestStatusEntity>? requestStatuses,
    Nullable<RequestStatusEntity?>? selectedRequestStatus,
    BlocRequestStatus? municipalitiesStatus,
    BlocRequestStatus? requestTypesStatus,
    List<RequestTypeEntity>? requestTypes,
    Nullable<RequestTypeEntity?>? selectedRequestType,
    BlocRequestStatus? requestSubTypesStatus,
    List<RequestSubTypeEntity>? requestSubTypes,
    Nullable<RequestSubTypeEntity?>? selectedRequestSubType,
    Nullable<DateTime?>? selectedRequestDate,
    Nullable<DateForm?>? dateForm,
    String? requestNumberQuery,
    SortType? sortType,
    String? errorMessage,
    int? page,
    int? limit,
    bool? noMoreData,
  }) {
    return ObjectableTransactionState(
        requestsStatus: requestsStatus ?? this.requestsStatus,
        requests: requests ?? this.requests,
        requestStatusesStatus:
            requestStatusesStatus ?? this.requestStatusesStatus,
        requestStatuses: requestStatuses ?? this.requestStatuses,
        selectedRequestStatus: selectedRequestStatus == null
            ? this.selectedRequestStatus
            : selectedRequestStatus.value,
        requestTypesStatus: requestTypesStatus ?? this.requestTypesStatus,
        requestTypes: requestTypes ?? this.requestTypes,
        selectedRequestType: selectedRequestType == null
            ? this.selectedRequestType
            : selectedRequestType.value,
        requestSubTypesStatus:
            requestSubTypesStatus ?? this.requestSubTypesStatus,
        requestSubTypes: requestSubTypes ?? this.requestSubTypes,
        selectedRequestSubType: selectedRequestSubType == null
            ? this.selectedRequestSubType
            : selectedRequestSubType.value,
        selectedRequestDate: selectedRequestDate == null
            ? this.selectedRequestDate
            : selectedRequestDate.value,
        dateForm: dateForm == null ? this.dateForm : dateForm.value,
        requestNumberQuery: requestNumberQuery ?? this.requestNumberQuery,
        sortType: sortType ?? this.sortType,
        errorMessage: errorMessage ?? this.errorMessage,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        noMoreData: noMoreData ?? this.noMoreData,
        detailsStatus: detailsStatus ?? this.detailsStatus);
  }

  ObjectableTransactionState clearFilters() => ObjectableTransactionState(
        requestsStatus: requestsStatus,
        requests: requests,
        requestStatusesStatus: requestStatusesStatus,
        requestStatuses: requestStatuses,
        selectedRequestStatus: null,
        requestTypesStatus: requestTypesStatus,
        requestTypes: requestTypes,
        selectedRequestType: null,
        requestSubTypesStatus: requestSubTypesStatus,
        requestSubTypes: requestSubTypes,
        selectedRequestSubType: null,
        selectedRequestDate: null,
        dateForm: null,
        requestNumberQuery: requestNumberQuery,
        sortType: sortType,
        errorMessage: errorMessage,
        page: page,
        limit: limit,
        noMoreData: noMoreData,
      );

  @override
  List<Object?> get props => [
        requestsStatus,
        requests,
        requestStatusesStatus,
        requestStatuses,
        selectedRequestStatus,
        requestTypesStatus,
        requestTypes,
        selectedRequestType,
        requestSubTypesStatus,
        requestSubTypes,
        selectedRequestSubType,
        selectedRequestDate,
        dateForm,
        requestNumberQuery,
        sortType,
        errorMessage,
        page,
        limit,
        noMoreData,
        detailsStatus
      ];
}
