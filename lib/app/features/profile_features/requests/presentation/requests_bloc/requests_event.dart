part of 'requests_bloc.dart';

abstract class RequestsEvent extends Equatable {
  const RequestsEvent();

  @override
  List<Object?> get props => [];
}

class GetRequestsEvent extends RequestsEvent {}

class GetRequestStatusesEvent extends RequestsEvent {}

class RequestStatusSelectedEvent extends RequestsEvent {
  final RequestStatusEntity requestStatus;

  const RequestStatusSelectedEvent({required this.requestStatus});

  @override
  List<Object> get props => [requestStatus];
}

class GetMunicipalitiesEvent extends RequestsEvent {}

class MunicipalitySelectedEvent extends RequestsEvent {
  final MunicipalityEntity municipality;

  const MunicipalitySelectedEvent({required this.municipality});

  @override
  List<Object> get props => [municipality];
}

class GetSubMunicipalitiesEvent extends RequestsEvent {
  final MunicipalityEntity municipality;

  const GetSubMunicipalitiesEvent({required this.municipality});

  @override
  List<Object> get props => [municipality];
}

class SubMunicipalitySelectedEvent extends RequestsEvent {
  final SubMunicipalityEntity subMunicipality;

  const SubMunicipalitySelectedEvent({required this.subMunicipality});

  @override
  List<Object> get props => [subMunicipality];
}

class GetRequestTypesEvent extends RequestsEvent {}

class RequestTypeSelectedEvent extends RequestsEvent {
  final RequestTypeEntity requestType;

  const RequestTypeSelectedEvent({required this.requestType});

  @override
  List<Object> get props => [requestType];
}

class GetRequestSubtypesEvent extends RequestsEvent {
  final RequestTypeEntity requestType;

  const GetRequestSubtypesEvent({required this.requestType});

  @override
  List<Object> get props => [requestType];
}

class RequestSubTypeSelectedEvent extends RequestsEvent {
  final RequestSubTypeEntity requestSubtype;

  const RequestSubTypeSelectedEvent({required this.requestSubtype});

  @override
  List<Object> get props => [requestSubtype];
}

class SearchRequestsEvent extends RequestsEvent {
  final String query;

  const SearchRequestsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class RequestsLoadLookupsEvent extends RequestsEvent {}

class RequestsLoadMoreEvent extends RequestsEvent {}

class RequestDateSelectedEvent extends RequestsEvent {
  final DateTime date;
  final DateForm formDate;

  const RequestDateSelectedEvent({required this.date, required this.formDate});

  @override
  List<Object> get props => [date];
}

class RequestsSortChangedEvent extends RequestsEvent {
  final SortType sortType;

  const RequestsSortChangedEvent({required this.sortType});

  @override
  List<Object> get props => [sortType];
}

class ClearRequestsFiltersEvent extends RequestsEvent {}

class ApplyRequestsFiltersEvent extends RequestsEvent {}

class GetCRMRequestEvent extends RequestsEvent {
  final RequestsType crmRequestType;
  const GetCRMRequestEvent({required this.crmRequestType});
}

class SearchCRMRequestsEvent extends RequestsEvent {
  final String query;

  const SearchCRMRequestsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class ResetRequestsFiltersEvent extends RequestsEvent {
  final SortType selectedSortType;
  final RequestStatusEntity? selectedRequestStatus;
  final MunicipalityEntity? selectedMunicipality;
  final SubMunicipalityEntity? selectedSubMunicipality;
  final RequestTypeEntity? selectedRequestType;
  final RequestSubTypeEntity? selectedRequestSubType;
  final DateTime? selectedRequestDate;
  final DateForm? dateForm;

  const ResetRequestsFiltersEvent(
      {required this.selectedSortType,
      this.selectedRequestStatus,
      this.selectedMunicipality,
      this.selectedSubMunicipality,
      this.selectedRequestType,
      this.selectedRequestSubType,
      this.selectedRequestDate,
      this.dateForm});

  @override
  List<Object?> get props => [
        selectedSortType,
        selectedRequestStatus,
        selectedMunicipality,
        selectedSubMunicipality,
        selectedRequestType,
        selectedRequestSubType,
        selectedRequestDate,
        dateForm,
      ];
}
