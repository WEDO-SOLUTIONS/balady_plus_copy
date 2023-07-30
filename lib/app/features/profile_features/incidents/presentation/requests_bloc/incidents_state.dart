part of 'incidents_bloc.dart';

class IncidentsState extends Equatable {
  // request number query
  final String? requestNumberQuery;

  //error message
  final String? errorMessage;

  // CRM Requests List
  final CRMRequestEntity? crmRequests;
  final CRMRequestEntity? crmRequestsList;

  final BlocRequestStatus crmRequestsStatus;
  final RequestsType crmRequestType;

  const IncidentsState(
      {this.requestNumberQuery,
      this.errorMessage,
      this.crmRequests,
      this.crmRequestsList,
      this.crmRequestsStatus = BlocRequestStatus.initial,
      this.crmRequestType = RequestsType.INC});

  String get error => errorMessage ?? '';

  IncidentsState copyWith(
      {String? requestNumberQuery,
      String? errorMessage,
      CRMRequestEntity? crmRequests,
      CRMRequestEntity? crmRequestsList,
      BlocRequestStatus? crmRequestsStatus,
      RequestsType? crmRequestType}) {
    return IncidentsState(
        requestNumberQuery: requestNumberQuery ?? this.requestNumberQuery,
        errorMessage: errorMessage ?? this.errorMessage,
        crmRequests: crmRequests ?? this.crmRequests,
        crmRequestsList: crmRequestsList ?? this.crmRequestsList,
        crmRequestsStatus: crmRequestsStatus ?? this.crmRequestsStatus,
        crmRequestType: crmRequestType ?? this.crmRequestType);
  }

  @override
  List<Object?> get props => [
        requestNumberQuery,
        errorMessage,
        crmRequests,
        crmRequestsStatus,
        crmRequestsList,
        crmRequestType,
      ];
}
