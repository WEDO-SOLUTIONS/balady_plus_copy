part of 'objections_bloc.dart';

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

class GetObjectionDetailsEvent extends RequestsEvent {
  final String params;
  final String? serviceTypeId;
  final String? hashingRequestNumber;
  const GetObjectionDetailsEvent(
      {required this.params, this.serviceTypeId, this.hashingRequestNumber});
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

class ResetRequestsFiltersEvent extends RequestsEvent {
  final SortType selectedSortType;
  final RequestStatusEntity? selectedRequestStatus;
  final RequestTypeEntity? selectedRequestType;
  final RequestSubTypeEntity? selectedRequestSubType;
  final DateTime? selectedRequestDate;
  final DateForm? dateForm;

  const ResetRequestsFiltersEvent(
      {required this.selectedSortType,
      this.selectedRequestStatus,
      this.selectedRequestType,
      this.selectedRequestSubType,
      this.selectedRequestDate,
      this.dateForm});

  @override
  List<Object?> get props => [
        selectedSortType,
        selectedRequestStatus,
        selectedRequestType,
        selectedRequestSubType,
        selectedRequestDate,
        dateForm
      ];
}
