part of 'invoices_bloc.dart';

abstract class InvoicesEvent extends Equatable {
  const InvoicesEvent();

  @override
  List<Object> get props => [];
}

class GetInvoicesEvent extends InvoicesEvent {}

class GetInvoiceStatusesEvent extends InvoicesEvent {}

class InvoiceStatusSelectedEvent extends InvoicesEvent {
  final InvoiceStatusEntity requestStatus;

  const InvoiceStatusSelectedEvent({required this.requestStatus});

  @override
  List<Object> get props => [requestStatus];
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
  final InvoiceTypeEntity requestType;

  const InvoiceTypeSelectedEvent({required this.requestType});

  @override
  List<Object> get props => [requestType];
}

class GetInvoiceSubtypesEvent extends InvoicesEvent {
  final InvoiceTypeEntity requestType;

  const GetInvoiceSubtypesEvent({required this.requestType});

  @override
  List<Object> get props => [requestType];
}

class InvoiceSubTypeSelectedEvent extends InvoicesEvent {
  final InvoiceSubTypeEntity requestSubtype;

  const InvoiceSubTypeSelectedEvent({required this.requestSubtype});

  @override
  List<Object> get props => [requestSubtype];
}

class SearchInvoicesEvent extends InvoicesEvent {
  final String query;

  const SearchInvoicesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

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
