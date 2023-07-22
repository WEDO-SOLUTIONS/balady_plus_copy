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
  // license Date
  final DateTime? selectedLicenseEndDate;
  // license number query
  final String? licenseNumberQuery;
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
    this.selectedLicenseEndDate,
    this.licenseNumberQuery,
    this.sortType = SortType.desc,
    this.errorMessage,
    this.page = 0,
    this.dateForm,
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
    Nullable<LicenseStatusEntity?>? selectedLicenseStatus,
    BlocRequestStatus? municipalitiesStatus,
    List<MunicipalityEntity>? municipalities,
    Nullable<MunicipalityEntity?>? selectedMunicipality,
    BlocRequestStatus? subMunicipalitiesStatus,
    List<SubMunicipalityEntity>? subMunicipalities,
    Nullable<SubMunicipalityEntity?>? selectedSubMunicipality,
    BlocRequestStatus? licenseTypesStatus,
    List<LicenseTypeEntity>? licenseTypes,
    Nullable<LicenseTypeEntity?>? selectedLicenseType,
    Nullable<DateTime?>? selectedLicenseEndDate,
    String? licenseNumberQuery,
    SortType? sortType,
    Nullable<DateForm?>? dateForm,
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
      selectedLicenseStatus: selectedLicenseStatus == null
          ? this.selectedLicenseStatus
          : selectedLicenseStatus.value,
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
      licenseTypesStatus: licenseTypesStatus ?? this.licenseTypesStatus,
      licenseTypes: licenseTypes ?? this.licenseTypes,
      selectedLicenseType: selectedLicenseType == null
          ? this.selectedLicenseType
          : selectedLicenseType.value,
      selectedLicenseEndDate: selectedLicenseEndDate == null
          ? this.selectedLicenseEndDate
          : selectedLicenseEndDate.value,
      licenseNumberQuery: licenseNumberQuery ?? this.licenseNumberQuery,
      sortType: sortType ?? this.sortType,
      dateForm: dateForm == null ? this.dateForm : dateForm.value,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      noMoreData: noMoreData ?? this.noMoreData,
    );
  }

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
        selectedLicenseEndDate,
        licenseNumberQuery,
        sortType,
        errorMessage,
        page,
        limit,
        noMoreData,
      ];
}
