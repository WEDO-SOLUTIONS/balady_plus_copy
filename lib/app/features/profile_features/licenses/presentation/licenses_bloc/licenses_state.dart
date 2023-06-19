part of 'licenses_bloc.dart';

class LicensesState extends Equatable {
  final BlocRequestStatus requestsStatus;
  final List<LicenseEntity> requests;
  //request statuses
  final BlocRequestStatus requestStatusesStatus;
  final List<LicenseStatusEntity> requestStatuses;
  final LicenseStatusEntity? selectedLicenseStatus;
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
  final List<LicenseTypeEntity> requestTypes;
  final LicenseTypeEntity? selectedLicenseType;
  //request sub types
  final BlocRequestStatus requestSubTypesStatus;
  final List<LicenseSubTypeEntity> requestSubTypes;
  final LicenseSubTypeEntity? selectedLicenseSubType;
  // request Date
  final DateTime? selectedLicenseDate;
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

  const LicensesState({
    this.requestsStatus = BlocRequestStatus.initial,
    this.requests = const [],
    this.requestStatusesStatus = BlocRequestStatus.initial,
    this.requestStatuses = const [],
    this.selectedLicenseStatus,
    this.municipalitiesStatus = BlocRequestStatus.initial,
    this.municipalities = const [],
    this.selectedMunicipality,
    this.subMunicipalitiesStatus = BlocRequestStatus.initial,
    this.subMunicipalities = const [],
    this.selectedSubMunicipality,
    this.requestTypesStatus = BlocRequestStatus.initial,
    this.requestTypes = const [],
    this.selectedLicenseType,
    this.requestSubTypesStatus = BlocRequestStatus.initial,
    this.requestSubTypes = const [],
    this.selectedLicenseSubType,
    this.selectedLicenseDate,
    this.requestNumberQuery,
    this.sortType = SortType.desc,
    this.errorMessage,
    this.page = 0,
    this.limit = PaginationConstants.limit,
    this.hasReachedMax = false,
  });

  String get error => errorMessage ?? '';

  LicensesState copyWith({
    BlocRequestStatus? requestsStatus,
    List<LicenseEntity>? requests,
    BlocRequestStatus? requestStatusesStatus,
    List<LicenseStatusEntity>? requestStatuses,
    LicenseStatusEntity? selectedLicenseStatus,
    BlocRequestStatus? municipalitiesStatus,
    List<MunicipalityEntity>? municipalities,
    MunicipalityEntity? selectedMunicipality,
    BlocRequestStatus? subMunicipalitiesStatus,
    List<SubMunicipalityEntity>? subMunicipalities,
    SubMunicipalityEntity? selectedSubMunicipality,
    BlocRequestStatus? requestTypesStatus,
    List<LicenseTypeEntity>? requestTypes,
    LicenseTypeEntity? selectedLicenseType,
    BlocRequestStatus? requestSubTypesStatus,
    List<LicenseSubTypeEntity>? requestSubTypes,
    LicenseSubTypeEntity? selectedLicenseSubType,
    DateTime? selectedLicenseDate,
    String? requestNumberQuery,
    SortType? sortType,
    String? errorMessage,
    int? page,
    int? limit,
    bool? hasReachedMax,
  }) {
    return LicensesState(
      requestsStatus: requestsStatus ?? this.requestsStatus,
      requests: requests ?? this.requests,
      requestStatusesStatus:
          requestStatusesStatus ?? this.requestStatusesStatus,
      requestStatuses: requestStatuses ?? this.requestStatuses,
      selectedLicenseStatus:
          selectedLicenseStatus ?? this.selectedLicenseStatus,
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
      selectedLicenseType: selectedLicenseType ?? this.selectedLicenseType,
      requestSubTypesStatus:
          requestSubTypesStatus ?? this.requestSubTypesStatus,
      requestSubTypes: requestSubTypes ?? this.requestSubTypes,
      selectedLicenseSubType:
          selectedLicenseSubType ?? this.selectedLicenseSubType,
      selectedLicenseDate: selectedLicenseDate ?? this.selectedLicenseDate,
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
        selectedLicenseStatus,
        municipalitiesStatus,
        municipalities,
        selectedMunicipality,
        subMunicipalitiesStatus,
        subMunicipalities,
        selectedSubMunicipality,
        requestTypesStatus,
        requestTypes,
        selectedLicenseType,
        requestSubTypesStatus,
        requestSubTypes,
        selectedLicenseSubType,
        selectedLicenseDate,
        requestNumberQuery,
        sortType,
        errorMessage,
        page,
        limit,
        hasReachedMax,
      ];
}
