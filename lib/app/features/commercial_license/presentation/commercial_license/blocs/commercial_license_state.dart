part of 'commercial_license_bloc.dart';

class CommercialLicenseState extends Equatable {
  final BlocStatus status;
  final BlocStatus detailsStatus;
  final int currentPageValue;
  final List<Widget> pagesList;
  final int? requestId;
  final SaveLocationResponse? locationResponse;
  final GISResponse? gisResponse;
  final ApplyCommercialResponseModel? applyCommercialResponse;
  final CrCalculateFeesResponse? crCalculateFeesResponse;
  final String? selectedPeriod;
  final bool? isDraft;
  final CommercialRequestDetailsResponse? requestData;
  final RecordInfo? recordInfo;

  const CommercialLicenseState({
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
    this.requestData,
    this.recordInfo,
    this.pagesList = const [
      CRStep1ApplicantData(),
      CRStep2ActivityData(),
      CRStep3GeolocationData(),
      CRStep4ShopData(),
      CRStep5AttachmentData(),
      CRStep6EstablishmentData(),
      //  CRStep7EstablishmentContactData(),
      //  CRStep8EmployeeData(),
      CRStep9WorkTimes(),
      CRStep10AdditionalData(),
      CRStep11AttachmentData(),
      CRStep12CalculatorReview(),
      CRStep13Review(),
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
        requestData,
        recordInfo
      ];

  CommercialLicenseState copyWith(
      {BlocStatus? status,
      BlocStatus? detailsStatus,
      int? currentPageValue,
      List<Widget>? pagesList,
      Nullable<int?>? requestId,
      SaveLocationResponse? locationResponse,
      ApplyCommercialResponseModel? applyCommercialResponse,
      CrCalculateFeesResponse? crCalculateFeesResponse,
      String? selectedPeriod,
      GISResponse? gisResponse,
      bool? isDraft,
      Nullable<CommercialRequestDetailsResponse?>? requestData,
      RecordInfo? recordInfo}) {
    return CommercialLicenseState(
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
        requestData: requestData == null ? this.requestData : requestData.value,
        recordInfo: recordInfo ?? this.recordInfo);
  }

  int? currentRequestIdText() {
    if (currentPageValue <= 4) return requestId;
    if (currentPageValue >= 5 && currentPageValue <= 8) {
      return applyCommercialResponse?.requestId;
    }

    return requestId;
  }
}
