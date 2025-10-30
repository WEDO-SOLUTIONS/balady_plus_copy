part of 'violations_bloc.dart';

abstract class ViolationsEvent extends Equatable {
  const ViolationsEvent();

  @override
  List<Object?> get props => [];
}

class GetViolationsEvent extends ViolationsEvent {}

class GetViolationsStatusesEvent extends ViolationsEvent {}

class ViolationsStatusSelectedEvent extends ViolationsEvent {
  final ViolationsStatusEntity violationsStatus;

  const ViolationsStatusSelectedEvent({required this.violationsStatus});

  @override
  List<Object> get props => [violationsStatus];
}

class GetInvoiceStatusesEvent extends ViolationsEvent {}

class InvoiceStatusesSelectedEvent extends ViolationsEvent {
  final InvoiceStatusesEntity invoiceStatus;

  const InvoiceStatusesSelectedEvent({required this.invoiceStatus});

  @override
  List<Object> get props => [invoiceStatus];
}

class ViolationsSortChangedEvent extends ViolationsEvent {
  final SortType sortType;

  const ViolationsSortChangedEvent({required this.sortType});

  @override
  List<Object> get props => [sortType];
}

class SearchWithViolationNumberEvent extends ViolationsEvent {
  final String query;

  const SearchWithViolationNumberEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class SearchWithLicenseNumberEvent extends ViolationsEvent {
  final String query;

  const SearchWithLicenseNumberEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class ViolationsLoadLookupsEvent extends ViolationsEvent {}

class ViolationsLoadMoreEvent extends ViolationsEvent {}

class ObjectionLastApplyDateSelectedEvent extends ViolationsEvent {
  final DateTime date;
  final DateForm formDate;

  const ObjectionLastApplyDateSelectedEvent(
      {required this.date, required this.formDate});

  @override
  List<Object> get props => [date];
}

class ViolationIssueDateSelectedEvent extends ViolationsEvent {
  final DateTime date;
  final DateForm formDate;

  const ViolationIssueDateSelectedEvent(
      {required this.date, required this.formDate});

  @override
  List<Object> get props => [date];
}

class ClearViolationsFiltersEvent extends ViolationsEvent {}

class ApplyViolationsFiltersEvent extends ViolationsEvent {}

class ResetViolationsFiltersEvent extends ViolationsEvent {
  final SortType selectedSortType;
  final ViolationsStatusEntity? selectedRequestStatus;
  final InvoiceStatusesEntity? selectedRequestType;
  final DateTime? selectedRequestDate;
  final DateForm? dateForm;

  const ResetViolationsFiltersEvent(
      {required this.selectedSortType,
      this.selectedRequestStatus,
      this.selectedRequestType,
      this.selectedRequestDate,
      this.dateForm});

  @override
  List<Object?> get props => [
        selectedSortType,
        selectedRequestStatus,
        selectedRequestType,
        selectedRequestDate,
        dateForm
      ];
}
