part of 'commercial_license_initial_Approval_bloc.dart';

class CommercialLicenseInitialApprovalState extends Equatable {
  final BlocStatus status;
  final BlocStatus detailsStatus;
  final int currentPageValue;
  final List<Widget> pagesList;
  final int? requestId;
  final SaveLocationResponse? locationResponse;
  final GISResponse? gisResponse;
  final SubmitCommercialResponseModel? applyCommercialResponse;
  final CalculateFeesResponseModel? crCalculateFeesResponse;
  final String? selectedPeriod;
  final bool? isDraft;
  // final CommercialRequestDetailsResponseEntity? requestData;
  final RequestDetailsModel? requestDetails;
  const CommercialLicenseInitialApprovalState({
    this.status = BlocStatus.initial,
    this.detailsStatus = BlocStatus.initial,
    this.currentPageValue = 0,
    this.requestId,
    this.locationResponse,
    this.applyCommercialResponse,
    this.crCalculateFeesResponse,
    this.selectedPeriod,
    this.gisResponse,
    this.isDraft,
    // this.requestData,
    this.requestDetails,

    this.pagesList = const [
      CRStep1ApplicantData(),
      Step2IntialApprovalActivityData(),
      Step3ConclusionPage()



    ],
  });

  @override
  List<Object?> get props => [
        status,
        detailsStatus,
        currentPageValue,
        pagesList,
        requestId,
        locationResponse,
        crCalculateFeesResponse,
        selectedPeriod,
        gisResponse,
        isDraft,
        // requestData,
        requestDetails
      ];

  CommercialLicenseInitialApprovalState copyWith(
      {BlocStatus? status,
      BlocStatus? detailsStatus,
      int? currentPageValue,
      List<Widget>? pagesList,
      Nullable<int?>? requestId,
      SaveLocationResponse? locationResponse,
      SubmitCommercialResponseModel? applyCommercialResponse,
        CalculateFeesResponseModel? crCalculateFeesResponse,
      String? selectedPeriod,
      GISResponse? gisResponse,
      bool? isDraft,
      //Nullable<CommercialRequestDetailsResponseEntity?>? requestData,
        RequestDetailsModel? requestDetails}) {
    return CommercialLicenseInitialApprovalState(
        status: status ?? this.status,
        detailsStatus: detailsStatus ?? this.detailsStatus,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        pagesList: pagesList ?? this.pagesList,
        requestId: requestId == null ? this.requestId : requestId.value,
        crCalculateFeesResponse:
            crCalculateFeesResponse ?? this.crCalculateFeesResponse,
        selectedPeriod: selectedPeriod ?? this.selectedPeriod,
        applyCommercialResponse:
            applyCommercialResponse ?? this.applyCommercialResponse,
        locationResponse: locationResponse ?? this.locationResponse,
        gisResponse: gisResponse ?? this.gisResponse,
        isDraft: isDraft ?? this.isDraft,
        // requestData: requestData == null ? this.requestData : requestData.value,
        requestDetails: requestDetails ?? this.requestDetails,
    );
  }

  int? currentRequestIdText() {
    if (currentPageValue <= 4) return requestId;
    if (currentPageValue >= 5 && currentPageValue <= 8) {
      return applyCommercialResponse?.requestId;
    }

    return requestId;
  }
}
