part of 'investment_details_bloc.dart';

class InvestmentDetailsState extends Equatable {
  // request number query
  final String? requestNumberQuery;

  //error message
  final String? errorMessage;

  final BlocRequestStatus crmRequestsStatus;

  const InvestmentDetailsState({
    this.requestNumberQuery,
    this.errorMessage,
    this.crmRequestsStatus = BlocRequestStatus.initial,
  });

  String get error => errorMessage ?? '';

  InvestmentDetailsState copyWith({
    String? requestNumberQuery,
    String? errorMessage,
    BlocRequestStatus? crmRequestsStatus,
  }) {
    return InvestmentDetailsState(
      requestNumberQuery: requestNumberQuery ?? this.requestNumberQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      crmRequestsStatus: crmRequestsStatus ?? this.crmRequestsStatus,
    );
  }

  @override
  List<Object?> get props => [
        requestNumberQuery,
        errorMessage,
        crmRequestsStatus,
      ];
}
