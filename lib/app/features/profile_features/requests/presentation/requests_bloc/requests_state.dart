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
  //error message
  final String? errorMessage;
  // pagination
  final int page;
  final int limit;
  final bool noMoreData;

  const RequestsState({
    this.requestsStatus = BlocRequestStatus.initial,
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
    this.page = 0,
    this.limit = PaginationConstants.limit,
    this.noMoreData = false,
  });

  String get error => errorMessage ?? '';
  bool get paginationLoading =>
      requestsStatus == BlocRequestStatus.submissionGetLoading && page > 0;

  RequestsState copyWith({
    BlocRequestStatus? requestsStatus,
    List<RequestEntity>? requests,
    BlocRequestStatus? requestStatusesStatus,
    List<RequestStatusEntity>? requestStatuses,
    RequestStatusEntity? selectedRequestStatus,
    BlocRequestStatus? municipalitiesStatus,
    List<MunicipalityEntity>? municipalities,
    MunicipalityEntity? selectedMunicipality,
    BlocRequestStatus? subMunicipalitiesStatus,
    List<SubMunicipalityEntity>? subMunicipalities,
    SubMunicipalityEntity? selectedSubMunicipality,
    BlocRequestStatus? requestTypesStatus,
    List<RequestTypeEntity>? requestTypes,
    RequestTypeEntity? selectedRequestType,
    BlocRequestStatus? requestSubTypesStatus,
    List<RequestSubTypeEntity>? requestSubTypes,
    RequestSubTypeEntity? selectedRequestSubType,
    DateTime? selectedRequestDate,
    String? requestNumberQuery,
    SortType? sortType,
    String? errorMessage,
    int? page,
    int? limit,
    bool? noMoreData,
  }) {
    return RequestsState(
      requestsStatus: requestsStatus ?? this.requestsStatus,
      requests: requests ?? this.requests,
      requestStatusesStatus:
          requestStatusesStatus ?? this.requestStatusesStatus,
      requestStatuses: requestStatuses ?? this.requestStatuses,
      selectedRequestStatus:
          selectedRequestStatus ?? this.selectedRequestStatus,
      municipalitiesStatus: municipalitiesStatus ?? this.municipalitiesStatus,
      municipalities: municipalities ?? this.municipalities,
      selectedMunicipality: selectedMunicipality ?? this.selectedMunicipality,
      subMunicipalitiesStatus:
          subMunicipalitiesStatus ?? this.subMunicipalitiesStatus,
      subMunicipalities: subMunicipalities ?? this.subMunicipalities,
      selectedSubMunicipality:
          selectedSubMunicipality ?? this.selectedSubMunicipality,
      requestTypesStatus: requestTypesStatus ?? this.requestTypesStatus,
      requestTypes: requestTypes ?? this.requestTypes,
      selectedRequestType: selectedRequestType ?? this.selectedRequestType,
      requestSubTypesStatus:
          requestSubTypesStatus ?? this.requestSubTypesStatus,
      requestSubTypes: requestSubTypes ?? this.requestSubTypes,
      selectedRequestSubType:
          selectedRequestSubType ?? this.selectedRequestSubType,
      selectedRequestDate: selectedRequestDate ?? this.selectedRequestDate,
      requestNumberQuery: requestNumberQuery ?? this.requestNumberQuery,
      sortType: sortType ?? this.sortType,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      noMoreData: noMoreData ?? this.noMoreData,
    );
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
        sortType,
        errorMessage,
        page,
        limit,
        noMoreData,
      ];
}
