part of 'crm_details_bloc.dart';

class CrmDetailsState extends Equatable {
  // request number query
  final String? requestNumberQuery;

  //error message
  final String? errorMessage;

  final BlocRequestStatus crmRequestsStatus;
  final RequestsType crmRequestType;

  final RequestDetailsResponse? details;
  final CrmRequestDetails? requestDetails;
  final RequestDetailsPageParams? pageParams;
  final List<DownloadFileResult>? files;

  const CrmDetailsState(
      {this.requestNumberQuery,
      this.errorMessage,
      this.crmRequestsStatus = BlocRequestStatus.initial,
      this.crmRequestType = RequestsType.INC,
      this.requestDetails,
      this.details,
      this.pageParams,
      this.files});

  String get error => errorMessage ?? '';

  CrmDetailsState copyWith(
      {String? requestNumberQuery,
      String? errorMessage,
      BlocRequestStatus? crmRequestsStatus,
      RequestsType? crmRequestType,
      RequestDetailsResponse? details,
      CrmRequestDetails? requestDetails,
      RequestDetailsPageParams? pageParams,
      List<DownloadFileResult>? files}) {
    return CrmDetailsState(
        requestNumberQuery: requestNumberQuery ?? this.requestNumberQuery,
        errorMessage: errorMessage ?? this.errorMessage,
        crmRequestType: crmRequestType ?? this.crmRequestType,
        details: details ?? this.details,
        requestDetails: requestDetails ?? this.requestDetails,
        pageParams: pageParams ?? this.pageParams,
        crmRequestsStatus: crmRequestsStatus ?? this.crmRequestsStatus,
        files: files ?? this.files);
  }

  @override
  List<Object?> get props => [
        requestNumberQuery,
        errorMessage,
        details,
        crmRequestsStatus,
        crmRequestType,
        requestDetails,
        pageParams,
        files
      ];
}
