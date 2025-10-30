part of 'survey_report_inquery_details_cubit.dart';

class SurveyReportInqueryDetailsState extends Equatable {
  final BlocRequestStatus status;
  final SurveyDataModel? licenceQueryDetails;
  //error message
  final String? errorMessage;

  const SurveyReportInqueryDetailsState({
    this.status = BlocRequestStatus.initial,
    this.licenceQueryDetails,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  SurveyReportInqueryDetailsState copyWith({
    BlocRequestStatus? status,
    SurveyDataModel? commercialLicenceDetails,
    String? errorMessage,
  }) {
    return SurveyReportInqueryDetailsState(
      status: status ?? this.status,
      licenceQueryDetails: commercialLicenceDetails ?? licenceQueryDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        licenceQueryDetails,
        errorMessage,
      ];
}
