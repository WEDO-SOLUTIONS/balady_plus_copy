part of 'commercial_license_bloc.dart';

class CommercialLicenseState extends Equatable {
  final BlocStatus status;
  final int currentPageValue;
  final List<Widget> pagesList;
  final int? requestId;
  final SaveLocationResponse? locationResponse;

  const CommercialLicenseState({
    this.status = BlocStatus.initial,
    this.currentPageValue = 0,
    this.requestId,
    this.locationResponse,
    this.pagesList = const [
      CRStep1ApplicantData(),
      CRStep2ActivityData(),
      CRStep3GeolocationData(),
      CRStep4ShopData(),
      CRStep5AttachmentData(),
      CRStep6EstablishmentData(),
      CRStep7EstablishmentContactData(),
      CRStep8EmployeeData(),
      CRStep9WorkTimes(),
      CRStep10AdditionalData(),
      CRStep11RequestReview(),
    ],
  });

  @override
  List<Object?> get props =>
      [status, currentPageValue, pagesList, requestId, locationResponse];

  CommercialLicenseState copyWith(
      {BlocStatus? status,
      int? currentPageValue,
      List<Widget>? pagesList,
      int? requestId,
      SaveLocationResponse? locationResponse}) {
    return CommercialLicenseState(
        status: status ?? this.status,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        pagesList: pagesList ?? this.pagesList,
        requestId: requestId ?? this.requestId,
        locationResponse: locationResponse ?? this.locationResponse);
  }
}
