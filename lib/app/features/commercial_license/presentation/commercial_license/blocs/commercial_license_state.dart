part of 'commercial_license_bloc.dart';

class CommercialLicenseState extends Equatable {
  final BlocStatus status;
  final int currentPageValue;
  final List<Widget> pagesList;
  final int? requestId;
  final SaveLocationResponse? locationResponse;
  final GISResponse? gisResponse;
  final ApplyCommercialResponseModel? applyCommercialResponse;
  final CrCalculateFeesResponse? crCalculateFeesResponse;
  final String? selectedPeriod;
  final bool? isDraft;

  const CommercialLicenseState({
    this.status = BlocStatus.initial,
    this.currentPageValue = 0,
    this.requestId,
    this.locationResponse,
    this.applyCommercialResponse,
    this.crCalculateFeesResponse,
    this.selectedPeriod,
    this.gisResponse,
    this.isDraft,
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
        currentPageValue,
        pagesList,
        requestId,
        locationResponse,
        crCalculateFeesResponse,
        selectedPeriod,
        gisResponse,
        isDraft
      ];

  CommercialLicenseState copyWith(
      {BlocStatus? status,
      int? currentPageValue,
      List<Widget>? pagesList,
      int? requestId,
      SaveLocationResponse? locationResponse,
      ApplyCommercialResponseModel? applyCommercialResponse,
      CrCalculateFeesResponse? crCalculateFeesResponse,
      String? selectedPeriod,
      GISResponse? gisResponse,
      bool? isDraft}) {
    return CommercialLicenseState(
        status: status ?? this.status,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        pagesList: pagesList ?? this.pagesList,
        requestId: requestId ?? this.requestId,
        crCalculateFeesResponse:
            crCalculateFeesResponse ?? this.crCalculateFeesResponse,
        selectedPeriod: selectedPeriod ?? this.selectedPeriod,
        applyCommercialResponse:
            applyCommercialResponse ?? this.applyCommercialResponse,
        locationResponse: locationResponse ?? this.locationResponse,
        gisResponse: gisResponse ?? this.gisResponse,
        isDraft: isDraft ?? this.isDraft);
  }

  int? currentRequestIdText() {
    if (currentPageValue <= 4) return requestId;
    if (currentPageValue >= 5 && currentPageValue <= 8) {
      return applyCommercialResponse?.requestId;
    }

    return requestId;
  }
}
