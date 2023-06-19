part of 'licenses_bloc.dart';

abstract class LicensesEvent extends Equatable {
  const LicensesEvent();

  @override
  List<Object> get props => [];
}

class GetLicensesEvent extends LicensesEvent {}

class GetLicenseStatusesEvent extends LicensesEvent {}

class LicenseStatusSelectedEvent extends LicensesEvent {
  final LicenseStatusEntity requestStatus;

  const LicenseStatusSelectedEvent({required this.requestStatus});

  @override
  List<Object> get props => [requestStatus];
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
  final LicenseTypeEntity requestType;

  const LicenseTypeSelectedEvent({required this.requestType});

  @override
  List<Object> get props => [requestType];
}

class GetLicenseSubtypesEvent extends LicensesEvent {
  final LicenseTypeEntity requestType;

  const GetLicenseSubtypesEvent({required this.requestType});

  @override
  List<Object> get props => [requestType];
}

class LicenseSubTypeSelectedEvent extends LicensesEvent {
  final LicenseSubTypeEntity requestSubtype;

  const LicenseSubTypeSelectedEvent({required this.requestSubtype});

  @override
  List<Object> get props => [requestSubtype];
}

class SearchLicensesEvent extends LicensesEvent {
  final String query;

  const SearchLicensesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class LicensesLoadMoreEvent extends LicensesEvent {}

class LicenseDateSelectedEvent extends LicensesEvent {
  final DateTime date;

  const LicenseDateSelectedEvent({required this.date});

  @override
  List<Object> get props => [date];
}

class LicensesSortChangedEvent extends LicensesEvent {
  final SortType sortType;

  const LicensesSortChangedEvent({required this.sortType});

  @override
  List<Object> get props => [sortType];
}
