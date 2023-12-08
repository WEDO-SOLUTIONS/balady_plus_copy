part of 'incidents_bloc.dart';

abstract class IncidentsEvent extends Equatable {
  const IncidentsEvent();

  @override
  List<Object?> get props => [];
}

class GetIncidentsEvent extends IncidentsEvent {}

class GetCRMRequestEvent extends IncidentsEvent {
  final RequestsType crmRequestType;
  const GetCRMRequestEvent({required this.crmRequestType});
}

class SearchCRMIncidentsEvent extends IncidentsEvent {
  final String query;

  const SearchCRMIncidentsEvent({required this.query});

  @override
  List<Object> get props => [query];
}
