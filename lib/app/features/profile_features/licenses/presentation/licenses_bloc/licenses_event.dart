part of 'licenses_bloc.dart';

abstract class LicensesEvent extends Equatable {
  const LicensesEvent();

  @override
  List<Object?> get props => [];
}

class GetLicensesEvent extends LicensesEvent {}

class GetLicenseStatusesEvent extends LicensesEvent {}

class LicenseStatusSelectedEvent extends LicensesEvent {
  final LicenseStatusEntity licenseStatus;

  const LicenseStatusSelectedEvent({required this.licenseStatus});

  @override
  List<Object> get props => [licenseStatus];
}

class GetMunicipalitiesEvent extends LicensesEvent {}

class MunicipalitySelectedEvent extends LicensesEvent {
  final MunicipalityEntity municipality;

  const MunicipalitySelectedEvent({required this.municipality});

  @override
  List<Object> get props => [municipality];
}

class GetSubMunicipalitiesEvent extends LicensesEvent {
  final MunicipalityEntity municipality;

  const GetSubMunicipalitiesEvent({required this.municipality});

  @override
  List<Object> get props => [municipality];
}

class SubMunicipalitySelectedEvent extends LicensesEvent {
  final SubMunicipalityEntity subMunicipality;

  const SubMunicipalitySelectedEvent({required this.subMunicipality});

  @override
  List<Object> get props => [subMunicipality];
}

class GetLicenseTypesEvent extends LicensesEvent {}

class LicenseTypeSelectedEvent extends LicensesEvent {
  final LicenseTypeEntity licenseType;

  const LicenseTypeSelectedEvent({required this.licenseType});

  @override
  List<Object> get props => [licenseType];
}

// class GetLicenseSubtypesEvent extends LicensesEvent {
//   final LicenseTypeEntity licenseType;

//   const GetLicenseSubtypesEvent({required this.licenseType});

//   @override
//   List<Object> get props => [licenseType];
// }

// class LicenseSubTypeSelectedEvent extends LicensesEvent {
//   final LicenseSubTypeEntity licenseSubtype;

//   const LicenseSubTypeSelectedEvent({required this.licenseSubtype});

//   @override
//   List<Object> get props => [licenseSubtype];
// }

class SearchLicensesEvent extends LicensesEvent {
  final String query;

  const SearchLicensesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class LicensesLoadLookupsEvent extends LicensesEvent {}

class LicensesLoadMoreEvent extends LicensesEvent {}

class LicenseDateSelectedEvent extends LicensesEvent {
  final DateTime date;
  final DateForm formDate;

  const LicenseDateSelectedEvent({required this.date, required this.formDate});

  @override
  List<Object> get props => [date];
}

class LicensesSortChangedEvent extends LicensesEvent {
  final SortType sortType;

  const LicensesSortChangedEvent({required this.sortType});

  @override
  List<Object> get props => [sortType];
}

class ClearLicensesFiltersEvent extends LicensesEvent {}

class ApplyLicensesFiltersEvent extends LicensesEvent {}

class ResetLicensesFiltersEvent extends LicensesEvent {
  final SortType selectedSortType;
  final LicenseStatusEntity? selectedLicenseStatus;
  final MunicipalityEntity? selectedMunicipality;
  final SubMunicipalityEntity? selectedSubMunicipality;
  final LicenseTypeEntity? selectedLicenseType;
  final DateTime? selectedLicenseDate;
  final DateForm? dateForm;

  const ResetLicensesFiltersEvent(
      {required this.selectedSortType,
      this.selectedLicenseStatus,
      this.selectedMunicipality,
      this.selectedSubMunicipality,
      this.selectedLicenseType,
      this.selectedLicenseDate,
      this.dateForm});

  @override
  List<Object?> get props => [
        selectedSortType,
        selectedLicenseStatus,
        selectedMunicipality,
        selectedSubMunicipality,
        selectedLicenseType,
        selectedLicenseDate,
        dateForm
      ];
}
