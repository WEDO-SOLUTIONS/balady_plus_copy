part of 'invoices_bloc.dart';

class InvoicesState extends Equatable {
  final BlocRequestStatus requestsStatus;
  final List<InvoiceEntity> requests;
  //request statuses
  final BlocRequestStatus requestStatusesStatus;
  final List<InvoiceStatusEntity> requestStatuses;
  final InvoiceStatusEntity? selectedInvoiceStatus;
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
  final List<InvoiceTypeEntity> requestTypes;
  final InvoiceTypeEntity? selectedInvoiceType;
  //request sub types
  final BlocRequestStatus requestSubTypesStatus;
  final List<InvoiceSubTypeEntity> requestSubTypes;
  final InvoiceSubTypeEntity? selectedInvoiceSubType;
  // request Date
  final DateTime? selectedInvoiceDate;
  // request number query
  final String? requestNumberQuery;
  //sort type
  final SortType sortType;
  //error message
  final String? errorMessage;
  // pagination
  final int page;
  final int limit;
  final bool hasReachedMax;

  const InvoicesState({
    this.requestsStatus = BlocRequestStatus.initial,
    this.requests = const [],
    this.requestStatusesStatus = BlocRequestStatus.initial,
    this.requestStatuses = const [],
    this.selectedInvoiceStatus,
    this.municipalitiesStatus = BlocRequestStatus.initial,
    this.municipalities = const [],
    this.selectedMunicipality,
    this.subMunicipalitiesStatus = BlocRequestStatus.initial,
    this.subMunicipalities = const [],
    this.selectedSubMunicipality,
    this.requestTypesStatus = BlocRequestStatus.initial,
    this.requestTypes = const [],
    this.selectedInvoiceType,
    this.requestSubTypesStatus = BlocRequestStatus.initial,
    this.requestSubTypes = const [],
    this.selectedInvoiceSubType,
    this.selectedInvoiceDate,
    this.requestNumberQuery,
    this.sortType = SortType.desc,
    this.errorMessage,
    this.page = 0,
    this.limit = PaginationConstants.limit,
    this.hasReachedMax = false,
  });

  String get error => errorMessage ?? '';

  InvoicesState copyWith({
    BlocRequestStatus? requestsStatus,
    List<InvoiceEntity>? requests,
    BlocRequestStatus? requestStatusesStatus,
    List<InvoiceStatusEntity>? requestStatuses,
    InvoiceStatusEntity? selectedInvoiceStatus,
    BlocRequestStatus? municipalitiesStatus,
    List<MunicipalityEntity>? municipalities,
    MunicipalityEntity? selectedMunicipality,
    BlocRequestStatus? subMunicipalitiesStatus,
    List<SubMunicipalityEntity>? subMunicipalities,
    SubMunicipalityEntity? selectedSubMunicipality,
    BlocRequestStatus? requestTypesStatus,
    List<InvoiceTypeEntity>? requestTypes,
    InvoiceTypeEntity? selectedInvoiceType,
    BlocRequestStatus? requestSubTypesStatus,
    List<InvoiceSubTypeEntity>? requestSubTypes,
    InvoiceSubTypeEntity? selectedInvoiceSubType,
    DateTime? selectedInvoiceDate,
    String? requestNumberQuery,
    SortType? sortType,
    String? errorMessage,
    int? page,
    int? limit,
    bool? hasReachedMax,
  }) {
    return InvoicesState(
      requestsStatus: requestsStatus ?? this.requestsStatus,
      requests: requests ?? this.requests,
      requestStatusesStatus:
          requestStatusesStatus ?? this.requestStatusesStatus,
      requestStatuses: requestStatuses ?? this.requestStatuses,
      selectedInvoiceStatus:
          selectedInvoiceStatus ?? this.selectedInvoiceStatus,
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
      selectedInvoiceType: selectedInvoiceType ?? this.selectedInvoiceType,
      requestSubTypesStatus:
          requestSubTypesStatus ?? this.requestSubTypesStatus,
      requestSubTypes: requestSubTypes ?? this.requestSubTypes,
      selectedInvoiceSubType:
          selectedInvoiceSubType ?? this.selectedInvoiceSubType,
      selectedInvoiceDate: selectedInvoiceDate ?? this.selectedInvoiceDate,
      requestNumberQuery: requestNumberQuery ?? this.requestNumberQuery,
      sortType: sortType ?? this.sortType,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        requestsStatus,
        requests,
        requestStatusesStatus,
        requestStatuses,
        selectedInvoiceStatus,
        municipalitiesStatus,
        municipalities,
        selectedMunicipality,
        subMunicipalitiesStatus,
        subMunicipalities,
        selectedSubMunicipality,
        requestTypesStatus,
        requestTypes,
        selectedInvoiceType,
        requestSubTypesStatus,
        requestSubTypes,
        selectedInvoiceSubType,
        selectedInvoiceDate,
        requestNumberQuery,
        sortType,
        errorMessage,
        page,
        limit,
        hasReachedMax,
      ];
}
