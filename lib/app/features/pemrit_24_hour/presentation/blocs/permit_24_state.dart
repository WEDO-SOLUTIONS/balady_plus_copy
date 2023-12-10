part of 'permit_24_bloc.dart';

class Permit24LicenseState extends Equatable {
  final int? groupId;
  final BlocStatus status;
  final BlocStatus detailsStatus;
  final BlocStatus alertsStatus;

  final int currentPageValue;
  final List<Widget> pagesList;
  final int? requestId;
  final String? error;
  final bool? isDraft;
  final List<PermitAlertItem>? alerts;
  final int? licenseId;
  final bool? agreement;
  final CalculateCost24PermitResponse? calculateCost24PermitResponse;
  final Permit24RequestDetailsModel? requestDetails;
  final CommercialLicenceDetails? commercialLicenceDetails;
  const Permit24LicenseState({
    this.status = BlocStatus.initial,
    this.detailsStatus = BlocStatus.initial,
    this.alertsStatus = BlocStatus.initial,
    this.licenseId,
    this.groupId,
    this.currentPageValue = 0,
    this.requestId,
    this.isDraft,
    this.error,
    this.alerts,
    this.agreement,
    this.calculateCost24PermitResponse,
    this.requestDetails,
    this.commercialLicenceDetails,
    this.pagesList = const [
      PermitStep1Page(),
    ],
  });

  @override
  List<Object?> get props => [
        status,
        detailsStatus,
        currentPageValue,
        pagesList,
        requestId,
        isDraft,
        error,
        groupId,
        alertsStatus,
        alerts,
        licenseId,
        agreement,
        calculateCost24PermitResponse,
        requestDetails,
        commercialLicenceDetails
      ];

  Permit24LicenseState copyWith(
      {BlocStatus? status,
      BlocStatus? posterTypesStatus,
      BlocStatus? detailsStatus,
      BlocStatus? alertsStatus,
      int? currentPageValue,
      List<Widget>? pagesList,
      Nullable<int?>? requestId,
      bool? isDraft,
      String? error,
      List<PermitAlertItem>? alerts,
      int? licenseId,
      bool? agreement,
      CalculateCost24PermitResponse? calculateCost24PermitResponse,
      Permit24RequestDetailsModel? requestDetails,
      CommercialLicenceDetails? commercialLicenceDetails}) {
    return Permit24LicenseState(
        calculateCost24PermitResponse:
            calculateCost24PermitResponse ?? this.calculateCost24PermitResponse,
        status: status ?? this.status,
        alertsStatus: alertsStatus ?? this.alertsStatus,
        detailsStatus: detailsStatus ?? this.detailsStatus,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        pagesList: pagesList ?? this.pagesList,
        requestId: requestId == null ? this.requestId : requestId.value,
        isDraft: isDraft ?? this.isDraft,
        error: error ?? this.error,
        groupId: groupId ?? this.groupId,
        alerts: alerts ?? this.alerts,
        licenseId: licenseId ?? this.licenseId,
        agreement: agreement ?? this.agreement,
        requestDetails: requestDetails ?? this.requestDetails,
        commercialLicenceDetails:
            commercialLicenceDetails ?? this.commercialLicenceDetails);
  }

  String? ALERT_SERVICE_USAGE_GUIDANCE() => alerts
      ?.firstWhereOrNull(
          (element) => element.id == "TWENTY_FOUR_PERMIT_ENDORSEMENT")
      ?.name
      ?.replaceAll("{0}", CommonProperties.userInfo?.arName ?? "");

  bool isStep2Valid() {
    if (true) {
      return false;
    }
  }
}
