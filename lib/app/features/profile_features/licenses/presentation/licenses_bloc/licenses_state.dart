part of 'licenses_bloc.dart';

class LicensesState extends Equatable {
  final BlocRequestStatus licensesStatus;
  final List<LicenseEntity> licenses;
  //license statuses
  final BlocRequestStatus licenseStatusesStatus;
  final List<LicenseStatusEntity> licenseStatuses;
  final LicenseStatusEntity? selectedLicenseStatus;
  //municipalities
  final BlocRequestStatus municipalitiesStatus;
  final List<MunicipalityEntity> municipalities;
  final MunicipalityEntity? selectedMunicipality;
  //sub municipalities
  final BlocRequestStatus subMunicipalitiesStatus;
  final List<SubMunicipalityEntity> subMunicipalities;
  final SubMunicipalityEntity? selectedSubMunicipality;
  //license types
  final BlocRequestStatus licenseTypesStatus;
  final List<LicenseTypeEntity> licenseTypes;
  final LicenseTypeEntity? selectedLicenseType;
  //license sub types
  final BlocRequestStatus licenseSubTypesStatus;
  final List<LicenseSubTypeEntity> licenseSubTypes;
  final LicenseSubTypeEntity? selectedLicenseSubType;
  // license Date
  final DateTime? selectedLicenseDate;
  // license number query
  final String? licenseNumberQuery;
  //sort type
  final SortType sortType;
  //error message
  final String? errorMessage;
  // pagination
  final int page;
  final int limit;
  final bool noMoreData;

  const LicensesState({
    this.licensesStatus = BlocRequestStatus.initial,
    this.licenses = const [],
    this.licenseStatusesStatus = BlocRequestStatus.initial,
    this.licenseStatuses = const [],
    this.selectedLicenseStatus,
    this.municipalitiesStatus = BlocRequestStatus.initial,
    this.municipalities = const [],
    this.selectedMunicipality,
    this.subMunicipalitiesStatus = BlocRequestStatus.initial,
    this.subMunicipalities = const [],
    this.selectedSubMunicipality,
    this.licenseTypesStatus = BlocRequestStatus.initial,
    this.licenseTypes = const [],
    this.selectedLicenseType,
    this.licenseSubTypesStatus = BlocRequestStatus.initial,
    this.licenseSubTypes = const [],
    this.selectedLicenseSubType,
    this.selectedLicenseDate,
    this.licenseNumberQuery,
    this.sortType = SortType.desc,
    this.errorMessage,
    this.page = 0,
    this.limit = PaginationConstants.limit,
    this.noMoreData = false,
  });

  String get error => errorMessage ?? '';
  bool get paginationLoading =>
      licensesStatus == BlocRequestStatus.submissionGetLoading && page > 0;

  LicensesState copyWith({
    BlocRequestStatus? licensesStatus,
    List<LicenseEntity>? licenses,
    BlocRequestStatus? licenseStatusesStatus,
    List<LicenseStatusEntity>? licenseStatuses,
    LicenseStatusEntity? selectedLicenseStatus,
    BlocRequestStatus? municipalitiesStatus,
    List<MunicipalityEntity>? municipalities,
    MunicipalityEntity? selectedMunicipality,
    BlocRequestStatus? subMunicipalitiesStatus,
    List<SubMunicipalityEntity>? subMunicipalities,
    SubMunicipalityEntity? selectedSubMunicipality,
    BlocRequestStatus? licenseTypesStatus,
    List<LicenseTypeEntity>? licenseTypes,
    LicenseTypeEntity? selectedLicenseType,
    BlocRequestStatus? licenseSubTypesStatus,
    List<LicenseSubTypeEntity>? licenseSubTypes,
    LicenseSubTypeEntity? selectedLicenseSubType,
    DateTime? selectedLicenseDate,
    String? licenseNumberQuery,
    SortType? sortType,
    String? errorMessage,
    int? page,
    int? limit,
    bool? noMoreData,
  }) {
    return LicensesState(
      licensesStatus: licensesStatus ?? this.licensesStatus,
      licenses: licenses ?? this.licenses,
      licenseStatusesStatus:
          licenseStatusesStatus ?? this.licenseStatusesStatus,
      licenseStatuses: licenseStatuses ?? this.licenseStatuses,
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
      licenseTypesStatus: licenseTypesStatus ?? this.licenseTypesStatus,
      licenseTypes: licenseTypes ?? this.licenseTypes,
      selectedLicenseType: selectedLicenseType ?? this.selectedLicenseType,
      licenseSubTypesStatus:
          licenseSubTypesStatus ?? this.licenseSubTypesStatus,
      licenseSubTypes: licenseSubTypes ?? this.licenseSubTypes,
      selectedLicenseSubType:
          selectedLicenseSubType ?? this.selectedLicenseSubType,
      selectedLicenseDate: selectedLicenseDate ?? this.selectedLicenseDate,
      licenseNumberQuery: licenseNumberQuery ?? this.licenseNumberQuery,
      sortType: sortType ?? this.sortType,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      noMoreData: noMoreData ?? this.noMoreData,
    );
  }

  LicensesState clearFilters() => LicensesState(
        licensesStatus: licensesStatus,
        licenses: licenses,
        licenseStatusesStatus: licenseStatusesStatus,
        licenseStatuses: licenseStatuses,
        selectedLicenseStatus: null,
        municipalitiesStatus: municipalitiesStatus,
        municipalities: municipalities,
        selectedMunicipality: null,
        subMunicipalitiesStatus: subMunicipalitiesStatus,
        subMunicipalities: subMunicipalities,
        selectedSubMunicipality: null,
        licenseTypesStatus: licenseTypesStatus,
        licenseTypes: licenseTypes,
        selectedLicenseType: null,
        licenseSubTypesStatus: licenseSubTypesStatus,
        licenseSubTypes: licenseSubTypes,
        selectedLicenseSubType: null,
        selectedLicenseDate: selectedLicenseDate,
        licenseNumberQuery: licenseNumberQuery,
        sortType: sortType,
        errorMessage: errorMessage,
        page: page,
        limit: limit,
        noMoreData: noMoreData,
      );

  @override
  List<Object?> get props => [
        licensesStatus,
        licenses,
        licenseStatusesStatus,
        licenseStatuses,
        selectedLicenseStatus,
        municipalitiesStatus,
        municipalities,
        selectedMunicipality,
        subMunicipalitiesStatus,
        subMunicipalities,
        selectedSubMunicipality,
        licenseTypesStatus,
        licenseTypes,
        selectedLicenseType,
        licenseSubTypesStatus,
        licenseSubTypes,
        selectedLicenseSubType,
        selectedLicenseDate,
        licenseNumberQuery,
        sortType,
        errorMessage,
        page,
        limit,
        noMoreData,
      ];
}
