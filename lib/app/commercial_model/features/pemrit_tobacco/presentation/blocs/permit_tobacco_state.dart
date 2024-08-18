part of 'permit_tobacco_bloc.dart';

class PermitTobaccoLicenseState extends Equatable {
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
  final CalculateCostPermitTobaccoResponse? calculateCost24PermitResponse;
  final PermitTobaccoRequestDetailsModel? requestDetails;
  final CommercialLicenceDetails? commercialLicenceDetails;
  final String? hotelLicenseNumber;
  final bool? isInsideHotel;
  final PermitTobaccoValidateHotelLicense?
      permitTobaccoValidateHotelLicenseResponse;
  const PermitTobaccoLicenseState({
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
    this.isInsideHotel,
    this.hotelLicenseNumber,
    this.calculateCost24PermitResponse,
    this.requestDetails,
    this.commercialLicenceDetails,
    this.permitTobaccoValidateHotelLicenseResponse,
    this.pagesList = const [
      PermitStep1Page(),
      PermitStep2Page(),
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
        commercialLicenceDetails,
        hotelLicenseNumber,
        isInsideHotel,
        permitTobaccoValidateHotelLicenseResponse
      ];

  PermitTobaccoLicenseState copyWith(
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
      CalculateCostPermitTobaccoResponse? calculateCost24PermitResponse,
      PermitTobaccoRequestDetailsModel? requestDetails,
      CommercialLicenceDetails? commercialLicenceDetails,
      String? hotelLicenseNumber,
      bool? isInsideHotel,
      Nullable<PermitTobaccoValidateHotelLicense?>?
          permitTobaccoValidateHotelLicenseResponse}) {
    return PermitTobaccoLicenseState(
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
            commercialLicenceDetails ?? this.commercialLicenceDetails,
        hotelLicenseNumber: hotelLicenseNumber ?? this.hotelLicenseNumber,
        isInsideHotel: isInsideHotel ?? this.isInsideHotel,
        permitTobaccoValidateHotelLicenseResponse:
            permitTobaccoValidateHotelLicenseResponse == null
                ? this.permitTobaccoValidateHotelLicenseResponse
                : permitTobaccoValidateHotelLicenseResponse.value);
  }

  String? ALERT() => alerts
      ?.firstWhereOrNull((element) =>
          element.id == "PERMIT_FEES_DIFFER_ACCORDING_TO_MUNICIPALITY")
      ?.name;

  bool isStep1Valid() {
    if (isInsideHotel == null) {
      return false;
    }

    if ((isInsideHotel == true && (hotelLicenseNumber?.isEmpty ?? true)) ||
        (isInsideHotel == true &&
            permitTobaccoValidateHotelLicenseResponse == null)) return false;

    return true;
  }

  bool needsFees() {
    LicenseAllowedPermitsInfo? info = commercialLicenceDetails
        ?.licenseAllowedPermitsInfo
        ?.firstWhereOrNull((element) => element.id == 1026);

    return info?.withFees == true;
  }

  bool doesNotNeedsCredentials() {
    LicenseAllowedPermitsInfo? info = commercialLicenceDetails
        ?.licenseAllowedPermitsInfo
        ?.firstWhereOrNull((element) => element.id == 1026);

    return info?.baladyWorkFlow?.id == "IMMEDIATE";
  }
}
