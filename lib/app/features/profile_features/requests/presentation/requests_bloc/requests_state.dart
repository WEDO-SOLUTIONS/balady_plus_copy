part of 'requests_bloc.dart';

class RequestsState extends Equatable {
  final BlocRequestStatus requestsStatus;
  final List<RequestEntity> requests;
  //request statuses
  final BlocRequestStatus requestStatusesStatus;
  final List<RequestStatusEntity> requestStatuses;
  final RequestStatusEntity? selectedRequestStatus;
  //municipalities
  final BlocRequestStatus municipalitiesStatus;
  final List<MunicipalityEntity> municipalities;
  final MunicipalityEntity? selectedMunicipality;
  //sub municipalities
  final BlocRequestStatus subMunicipalitiesStatus;
  final List<SubMunicipalityEntity> subMunicipalities;
  final SubMunicipalityEntity? selectedSubMunicipality;
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

  // CRM Requests List
  final CRMRequestEntity? crmRequests;
  final CRMRequestEntity? crmRequestsList;

  final BlocRequestStatus crmRequestsStatus;
  final RequestsType crmRequestType;

  const RequestsState(
      {this.requestsStatus = BlocRequestStatus.initial,
      this.requests = const [],
      this.requestStatusesStatus = BlocRequestStatus.initial,
      this.requestStatuses = const [],
      this.selectedRequestStatus,
      this.municipalitiesStatus = BlocRequestStatus.initial,
      this.municipalities = const [],
      this.selectedMunicipality,
      this.subMunicipalitiesStatus = BlocRequestStatus.initial,
      this.subMunicipalities = const [],
      this.selectedSubMunicipality,
      this.requestTypesStatus = BlocRequestStatus.initial,
      this.requestTypes = const [],
      this.selectedRequestType,
      this.requestSubTypesStatus = BlocRequestStatus.initial,
      this.requestSubTypes = const [],
      this.selectedRequestSubType,
      this.selectedRequestDate,
      this.requestNumberQuery,
      this.sortType = SortType.desc,
      this.errorMessage,
      this.dateForm,
      this.page = 0,
      this.limit = PaginationConstants.limit,
      this.noMoreData = false,
      this.crmRequests,
      this.crmRequestsList,
      this.crmRequestsStatus = BlocRequestStatus.initial,
      this.crmRequestType = RequestsType.MUN});

  String get error => errorMessage ?? '';
  bool get paginationLoading =>
      requestsStatus == BlocRequestStatus.submissionGetLoading && page > 0;

  RequestsState copyWith(
      {BlocRequestStatus? requestsStatus,
      List<RequestEntity>? requests,
      BlocRequestStatus? requestStatusesStatus,
      List<RequestStatusEntity>? requestStatuses,
      Nullable<RequestStatusEntity?>? selectedRequestStatus,
      BlocRequestStatus? municipalitiesStatus,
      List<MunicipalityEntity>? municipalities,
      Nullable<MunicipalityEntity?>? selectedMunicipality,
      BlocRequestStatus? subMunicipalitiesStatus,
      List<SubMunicipalityEntity>? subMunicipalities,
      Nullable<SubMunicipalityEntity?>? selectedSubMunicipality,
      BlocRequestStatus? requestTypesStatus,
      List<RequestTypeEntity>? requestTypes,
      Nullable<RequestTypeEntity?>? selectedRequestType,
      BlocRequestStatus? requestSubTypesStatus,
      List<RequestSubTypeEntity>? requestSubTypes,
      Nullable<RequestSubTypeEntity?>? selectedRequestSubType,
      Nullable<DateTime?>? selectedRequestDate,
      String? requestNumberQuery,
      SortType? sortType,
      Nullable<DateForm?>? dateForm,
      String? errorMessage,
      int? page,
      int? limit,
      bool? noMoreData,
      CRMRequestEntity? crmRequests,
      CRMRequestEntity? crmRequestsList,
      BlocRequestStatus? crmRequestsStatus,
      RequestsType? crmRequestType}) {
    return RequestsState(
        requestsStatus: requestsStatus ?? this.requestsStatus,
        requests: requests ?? this.requests,
        requestStatusesStatus:
            requestStatusesStatus ?? this.requestStatusesStatus,
        requestStatuses: requestStatuses ?? this.requestStatuses,
        selectedRequestStatus: selectedRequestStatus == null
            ? this.selectedRequestStatus
            : selectedRequestStatus.value,
        municipalitiesStatus: municipalitiesStatus ?? this.municipalitiesStatus,
        municipalities: municipalities ?? this.municipalities,
        selectedMunicipality: selectedMunicipality == null
            ? this.selectedMunicipality
            : selectedMunicipality.value,
        subMunicipalitiesStatus:
            subMunicipalitiesStatus ?? this.subMunicipalitiesStatus,
        subMunicipalities: subMunicipalities ?? this.subMunicipalities,
        selectedSubMunicipality: selectedSubMunicipality == null
            ? this.selectedSubMunicipality
            : selectedSubMunicipality.value,
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
        requestNumberQuery: requestNumberQuery ?? this.requestNumberQuery,
        sortType: sortType ?? this.sortType,
        dateForm: dateForm == null ? this.dateForm : dateForm.value,
        errorMessage: errorMessage ?? this.errorMessage,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        noMoreData: noMoreData ?? this.noMoreData,
        crmRequests: crmRequests ?? this.crmRequests,
        crmRequestsList: crmRequestsList ?? this.crmRequestsList,
        crmRequestsStatus: crmRequestsStatus ?? this.crmRequestsStatus,
        crmRequestType: crmRequestType ?? this.crmRequestType);
  }

  RequestsState clearFilters() => RequestsState(
        requestsStatus: requestsStatus,
        requests: requests,
        requestStatusesStatus: requestStatusesStatus,
        requestStatuses: requestStatuses,
        selectedRequestStatus: null,
        municipalitiesStatus: municipalitiesStatus,
        municipalities: municipalities,
        selectedMunicipality: null,
        subMunicipalitiesStatus: subMunicipalitiesStatus,
        subMunicipalities: subMunicipalities,
        selectedSubMunicipality: null,
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
        municipalitiesStatus,
        municipalities,
        selectedMunicipality,
        subMunicipalitiesStatus,
        subMunicipalities,
        selectedSubMunicipality,
        requestTypesStatus,
        requestTypes,
        selectedRequestType,
        requestSubTypesStatus,
        requestSubTypes,
        selectedRequestSubType,
        selectedRequestDate,
        requestNumberQuery,
        dateForm,
        sortType,
        errorMessage,
        page,
        limit,
        noMoreData,
        crmRequests,
        crmRequestsStatus,
        crmRequestType,
        crmRequestsList
      ];
}
