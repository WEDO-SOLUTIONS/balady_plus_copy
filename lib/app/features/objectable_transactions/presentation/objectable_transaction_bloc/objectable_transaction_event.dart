part of 'objectable_transaction_bloc.dart';

abstract class ObjectableTransactionEvent extends Equatable {
  const ObjectableTransactionEvent();

  @override
  List<Object?> get props => [];
}

class GetRequestsEvent extends ObjectableTransactionEvent {}

class GetRequestStatusesEvent extends ObjectableTransactionEvent {}

class RequestStatusSelectedEvent extends ObjectableTransactionEvent {
  final RequestStatusEntity requestStatus;

  const RequestStatusSelectedEvent({required this.requestStatus});

  @override
  List<Object> get props => [requestStatus];
}

class GetRequestTypesEvent extends ObjectableTransactionEvent {}

class RequestTypeSelectedEvent extends ObjectableTransactionEvent {
  final RequestTypeEntity requestType;

  const RequestTypeSelectedEvent({required this.requestType});

  @override
  List<Object> get props => [requestType];
}

class GetRequestSubtypesEvent extends ObjectableTransactionEvent {
  final RequestTypeEntity requestType;

  const GetRequestSubtypesEvent({required this.requestType});

  @override
  List<Object> get props => [requestType];
}

class RequestSubTypeSelectedEvent extends ObjectableTransactionEvent {
  final RequestSubTypeEntity requestSubtype;

  const RequestSubTypeSelectedEvent({required this.requestSubtype});

  @override
  List<Object> get props => [requestSubtype];
}

class SearchRequestsEvent extends ObjectableTransactionEvent {
  final String query;

  const SearchRequestsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class RequestsLoadLookupsEvent extends ObjectableTransactionEvent {}

class RequestsLoadMoreEvent extends ObjectableTransactionEvent {}

class RequestDateSelectedEvent extends ObjectableTransactionEvent {
  final DateTime date;
  final DateForm formDate;

  const RequestDateSelectedEvent({required this.date, required this.formDate});

  @override
  List<Object> get props => [date];
}

class GetTransactionDetailsEvent extends ObjectableTransactionEvent {
  final TransactionDetailsParams params;
  final bool apply;
  const GetTransactionDetailsEvent({required this.params, this.apply = false});
}

class ClearRequestsFiltersEvent extends ObjectableTransactionEvent {}

class ApplyRequestsFiltersEvent extends ObjectableTransactionEvent {}

class ResetRequestsFiltersEvent extends ObjectableTransactionEvent {
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

class ValidateObjectionTransactions extends ObjectableTransactionEvent {
  final ObjectableTransactionsEntity params;
  const ValidateObjectionTransactions({required this.params});
}
