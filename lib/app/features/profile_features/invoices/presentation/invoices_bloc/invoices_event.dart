part of 'invoices_bloc.dart';

abstract class InvoicesEvent extends Equatable {
  const InvoicesEvent();

  @override
  List<Object> get props => [];
}

class GetInvoicesEvent extends InvoicesEvent {}

class GetInvoiceStatusesEvent extends InvoicesEvent {}

class InvoiceStatusSelectedEvent extends InvoicesEvent {
  final InvoiceStatusEntity invoiceStatus;

  const InvoiceStatusSelectedEvent({required this.invoiceStatus});

  @override
  List<Object> get props => [invoiceStatus];
}

class GetMunicipalitiesEvent extends InvoicesEvent {}

class MunicipalitySelectedEvent extends InvoicesEvent {
  final MunicipalityEntity municipality;

  const MunicipalitySelectedEvent({required this.municipality});

  @override
  List<Object> get props => [municipality];
}

class GetSubMunicipalitiesEvent extends InvoicesEvent {
  final MunicipalityEntity municipality;

  const GetSubMunicipalitiesEvent({required this.municipality});

  @override
  List<Object> get props => [municipality];
}

class SubMunicipalitySelectedEvent extends InvoicesEvent {
  final SubMunicipalityEntity subMunicipality;

  const SubMunicipalitySelectedEvent({required this.subMunicipality});

  @override
  List<Object> get props => [subMunicipality];
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

class SearchInvoicesEvent extends InvoicesEvent {
  final String query;

  const SearchInvoicesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class InvoicesLoadLookupsEvent extends InvoicesEvent {}

class InvoicesLoadMoreEvent extends InvoicesEvent {}

class InvoiceDateSelectedEvent extends InvoicesEvent {
  final DateTime date;

  const InvoiceDateSelectedEvent({required this.date});

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
