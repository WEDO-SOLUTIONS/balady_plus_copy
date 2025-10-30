// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'invoices_bloc.dart';

abstract class InvoicesEvent extends Equatable {
  const InvoicesEvent();

  @override
  List<Object?> get props => [];
}

class GetInvoicesEvent extends InvoicesEvent {}

class GetInvoiceStatusesEvent extends InvoicesEvent {}

class InvoiceStatusSelectedEvent extends InvoicesEvent {
  final InvoiceStatusEntity invoiceStatus;

  const InvoiceStatusSelectedEvent({required this.invoiceStatus});

  @override
  List<Object> get props => [invoiceStatus];
}

class GetInvoiceTypesEvent extends InvoicesEvent {}

class InvoiceTypeSelectedEvent extends InvoicesEvent {
  final InvoiceTypeEntity invoiceType;

  const InvoiceTypeSelectedEvent({required this.invoiceType});

  @override
  List<Object> get props => [invoiceType];
}

class GetInvoiceSubtypesEvent extends InvoicesEvent {
  final InvoiceTypeEntity invoiceType;

  const GetInvoiceSubtypesEvent({required this.invoiceType});

  @override
  List<Object> get props => [invoiceType];
}

class InvoiceSubTypeSelectedEvent extends InvoicesEvent {
  final InvoiceSubTypeEntity invoiceSubtype;

  const InvoiceSubTypeSelectedEvent({required this.invoiceSubtype});

  @override
  List<Object> get props => [invoiceSubtype];
}

class SearchWithInvoiceNumberEvent extends InvoicesEvent {
  final String query;

  const SearchWithInvoiceNumberEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class SearchWithRequestNumberEvent extends InvoicesEvent {
  final String query;

  const SearchWithRequestNumberEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class InvoicesLoadLookupsEvent extends InvoicesEvent {}

class InvoicesLoadMoreEvent extends InvoicesEvent {}

class InvoiceDueDateSelectedEvent extends InvoicesEvent {
  final DateTime date;
  final DateForm formDate;

  const InvoiceDueDateSelectedEvent(
      {required this.date, required this.formDate});

  @override
  List<Object> get props => [date];
}

class InvoiceIssueDateSelectedEvent extends InvoicesEvent {
  final DateTime date;
  final DateForm formDate;

  const InvoiceIssueDateSelectedEvent(
      {required this.date, required this.formDate});

  @override
  List<Object> get props => [date];
}

class InvoicesSortChangedEvent extends InvoicesEvent {
  final SortType sortType;

  const InvoicesSortChangedEvent({required this.sortType});

  @override
  List<Object> get props => [sortType];
}

class ClearInvoicesFiltersEvent extends InvoicesEvent {}

class ApplyInvoicesFiltersEvent extends InvoicesEvent {}

class ResetInvoicesFiltersEvent extends InvoicesEvent {
  final SortType selectedSortType;
  final String? invoiceNumberQuery;
  final String? requestNumberQuery;
  final InvoiceStatusEntity? selectedInvoiceStatus;
  final InvoiceTypeEntity? selectedInvoiceType;
  final InvoiceSubTypeEntity? selectedInvoiceSubType;
  final DateTime? selectedInvoiceDueDate;
  final DateTime? selectedInvoiceIssueDate;
  final DateForm? dateFormForDueDate;
  final DateForm? dateFormForIssue;

  const ResetInvoicesFiltersEvent(
      {required this.selectedSortType,
      this.invoiceNumberQuery,
      this.requestNumberQuery,
      this.selectedInvoiceStatus,
      this.selectedInvoiceType,
      this.selectedInvoiceSubType,
      this.selectedInvoiceDueDate,
      this.selectedInvoiceIssueDate,
      this.dateFormForDueDate,
      this.dateFormForIssue});

  @override
  List<Object?> get props => [
        selectedSortType,
        invoiceNumberQuery,
        requestNumberQuery,
        selectedInvoiceStatus,
        selectedInvoiceType,
        selectedInvoiceSubType,
        selectedInvoiceDueDate,
        selectedInvoiceIssueDate,
        dateFormForIssue,
        dateFormForDueDate
      ];
}
