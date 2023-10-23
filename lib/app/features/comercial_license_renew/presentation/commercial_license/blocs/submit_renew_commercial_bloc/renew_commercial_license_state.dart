part of 'renew_commercial_license_bloc.dart';

class RenewCommercialLicenseState extends Equatable {
  final BlocStatus status;
  final BlocRequestStatus renewYearsStatus;
  final int currentPageValue;
  final List<Widget> pagesList;
  final int? requestId;
  final List<int>? renewYears;
  final int? licensePeriod;
  final RenewRequestInfo? info;
  final String? errorMessage;

  const RenewCommercialLicenseState({
    this.status = BlocStatus.initial,
    this.renewYearsStatus = BlocRequestStatus.initial,
    this.currentPageValue = 0,
    this.requestId,
    this.renewYears,
    this.licensePeriod,
    this.info,
    this.errorMessage,
    this.pagesList = const [
      CommercialRenewStep1(),
      CommercialRenewStep2(),
      CommercialRenewStep3(),
    ],
  });

  @override
  List<Object?> get props => [
        status,
        currentPageValue,
        pagesList,
        requestId,
        renewYears,
        info,
        licensePeriod,
        renewYearsStatus,
        errorMessage
      ];

  RenewCommercialLicenseState copyWith(
      {BlocStatus? status,
      int? currentPageValue,
      List<Widget>? pagesList,
      int? requestId,
      List<int>? renewYears,
      int? licensePeriod,
      RenewRequestInfo? info,
      BlocRequestStatus? renewYearsStatus,
      String? errorMessage}) {
    return RenewCommercialLicenseState(
        status: status ?? this.status,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        pagesList: pagesList ?? this.pagesList,
        requestId: requestId ?? this.requestId,
        renewYears: renewYears ?? this.renewYears,
        licensePeriod: licensePeriod ?? this.licensePeriod,
        info: info ?? this.info,
        renewYearsStatus: renewYearsStatus ?? this.renewYearsStatus,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
