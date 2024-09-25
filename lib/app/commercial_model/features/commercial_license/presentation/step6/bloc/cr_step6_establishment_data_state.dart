// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'cr_step6_establishment_data_cubit.dart';

class CRStep6EstablishmentState extends Equatable {
  final BlocStatus status;
  final BlocStatus paymentsMethodsStatus;
  final BlocStatus siteNatureStatus;
  final BlocStatus buildingNatureStatus;
  final BlocStatus applyStatus;
  final QRSiteLocationType? siteLocationType;
  final ContactInfo? contactInfo;
  final List<CrOwner>? crOwners;
  final CitizenInfoModel? managerInfo;
  final List<QrLookUpItem>? selectedPaymentMethods;
  final QrLookUpItem? selectedBuildingNature;
  final QrLookUpItem? selectedSiteNature;
  final NationalAddress? nationalAddress;
  final LocationOnStreetDto? locationOnStreetDto;
  final LocationInsideBuildingDto? locationInsideBuildingDto;
  final List<QrLookUpItem>? paymentsMethods;
  final List<QrLookUpItem>? siteNature;
  final List<QrLookUpItem>? buildingNature;
  final ApplyCommercialResponseModel? applyResponse;
  final String? errorMessage;

  final String? buildingName;
  final String? buildingUnit;
  final String? buildingFloor;
  final String? buildingDirections;

  final String? siteName;
  final String? siteDesc;
  final String? siteLandmark;

  final String? buildingNumber;
  final String? addetionalNumber;
  final String? postalCode;

  final bool? hasPaymentMethods;

  final String? birthDate;
  final String? nationalId;

  final String? managerMobileNumber;
  final bool? managerMobileNumberVerified;
  final SendOtpResponse? sendOtpResponse;
  PhoneNumberValidation get phoneValidator => managerMobileNumber == null
      ? PhoneNumberValidation.pure()
      : PhoneNumberValidation.dirty(value: managerMobileNumber);
  String? get phoneErrorText => phoneValidator.error?.message != null
      ? (phoneValidator.error?.message ?? "").tr()
      : null;

  EmailValidation get emailValidator => contactInfo?.mail == null
      ? EmailValidation.pure()
      : EmailValidation.dirty(email: contactInfo?.mail);
  String? get emailErrorText => emailValidator.error?.message != null
      ? (emailValidator.error?.message ?? "").tr()
      : null;

  const CRStep6EstablishmentState(
      {this.status = BlocStatus.initial,
      this.paymentsMethodsStatus = BlocStatus.initial,
      this.buildingNatureStatus = BlocStatus.initial,
      this.siteNatureStatus = BlocStatus.initial,
      this.applyStatus = BlocStatus.initial,
      this.errorMessage,
      this.siteLocationType,
      this.contactInfo,
      this.crOwners,
      this.managerInfo,
      this.selectedPaymentMethods,
      this.selectedBuildingNature,
      this.selectedSiteNature,
      this.nationalAddress,
      this.locationOnStreetDto,
      this.locationInsideBuildingDto,
      this.paymentsMethods,
      this.siteNature,
      this.buildingNature,
      this.applyResponse,
      this.buildingName,
      this.buildingUnit,
      this.buildingFloor,
      this.buildingDirections,
      this.siteName,
      this.siteDesc,
      this.siteLandmark,
      this.buildingNumber,
      this.addetionalNumber,
      this.postalCode,
      this.hasPaymentMethods,
      this.birthDate,
      this.nationalId,
      this.managerMobileNumber,
      this.managerMobileNumberVerified,
      this.sendOtpResponse});

  @override
  List<Object?> get props {
    return [
      status,
      siteLocationType,
      contactInfo,
      crOwners,
      managerInfo,
      selectedPaymentMethods,
      nationalAddress,
      locationOnStreetDto,
      locationInsideBuildingDto,
      errorMessage,
      paymentsMethods,
      siteNature,
      buildingNature,
      paymentsMethodsStatus,
      buildingNatureStatus,
      siteNatureStatus,
      applyResponse,
      selectedBuildingNature,
      selectedSiteNature,
      applyStatus,
      buildingName,
      buildingUnit,
      buildingFloor,
      buildingDirections,
      siteName,
      siteDesc,
      siteLandmark,
      buildingNumber,
      addetionalNumber,
      postalCode,
      hasPaymentMethods,
      birthDate,
      nationalId,
      managerMobileNumber,
      managerMobileNumberVerified,
      sendOtpResponse
    ];
  }

  CRStep6EstablishmentState copyWith({
    BlocStatus? status,
    QRSiteLocationType? siteLocationType,
    ContactInfo? contactInfo,
    List<CrOwner>? crOwners,
    Nullable<CitizenInfoModel?>? managerInfo,
    List<QrLookUpItem>? selectedPaymentMethods,
    NationalAddress? nationalAddress,
    LocationOnStreetDto? locationOnStreetDto,
    LocationInsideBuildingDto? locationInsideBuildingDto,
    String? errorMessage,
    List<QrLookUpItem>? paymentsMethods,
    List<QrLookUpItem>? siteNature,
    List<QrLookUpItem>? buildingNature,
    BlocStatus? paymentsMethodsStatus,
    BlocStatus? siteNatureStatus,
    BlocStatus? buildingNatureStatus,
    ApplyCommercialResponseModel? applyResponse,
    BlocStatus? applyStatus,
    QrLookUpItem? selectedBuildingNature,
    QrLookUpItem? selectedSiteNature,
    String? buildingName,
    String? buildingUnit,
    String? buildingFloor,
    String? buildingDirections,
    String? siteName,
    String? siteDesc,
    String? siteLandmark,
    String? buildingNumber,
    String? addetionalNumber,
    String? postalCode,
    bool? hasPaymentMethods,
    String? birthDate,
    String? nationalId,
    String? managerMobileNumber,
    Nullable<bool?>? managerMobileNumberVerified,
    final Nullable<SendOtpResponse?>? sendOtpResponse,
  }) {
    return CRStep6EstablishmentState(
      status: status ?? this.status,
      siteLocationType: siteLocationType ?? this.siteLocationType,
      contactInfo: contactInfo ?? this.contactInfo,
      crOwners: crOwners ?? this.crOwners,
      managerInfo: managerInfo == null ? this.managerInfo : managerInfo.value,
      selectedPaymentMethods:
          selectedPaymentMethods ?? this.selectedPaymentMethods,
      nationalAddress: nationalAddress ?? this.nationalAddress,
      locationOnStreetDto: locationOnStreetDto ?? this.locationOnStreetDto,
      locationInsideBuildingDto:
          locationInsideBuildingDto ?? this.locationInsideBuildingDto,
      errorMessage: errorMessage ?? this.errorMessage,
      paymentsMethods: paymentsMethods ?? this.paymentsMethods,
      siteNature: siteNature ?? this.siteNature,
      buildingNature: buildingNature ?? this.buildingNature,
      paymentsMethodsStatus:
          paymentsMethodsStatus ?? this.paymentsMethodsStatus,
      siteNatureStatus: siteNatureStatus ?? this.siteNatureStatus,
      buildingNatureStatus: buildingNatureStatus ?? this.buildingNatureStatus,
      applyStatus: applyStatus ?? this.applyStatus,
      selectedBuildingNature:
          selectedBuildingNature ?? this.selectedBuildingNature,
      selectedSiteNature: selectedSiteNature ?? this.selectedSiteNature,
      buildingName: buildingName ?? this.buildingName,
      buildingUnit: buildingUnit ?? this.buildingUnit,
      buildingFloor: buildingFloor ?? this.buildingFloor,
      buildingDirections: buildingDirections ?? this.buildingDirections,
      siteName: siteName ?? this.siteName,
      siteDesc: siteDesc ?? this.siteDesc,
      siteLandmark: siteLandmark ?? this.siteLandmark,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      addetionalNumber: addetionalNumber ?? this.addetionalNumber,
      postalCode: postalCode ?? this.postalCode,
      hasPaymentMethods: hasPaymentMethods ?? this.hasPaymentMethods,
      birthDate: birthDate ?? this.birthDate,
      nationalId: nationalId ?? this.nationalId,
      managerMobileNumber: managerMobileNumber ?? this.managerMobileNumber,
      managerMobileNumberVerified: managerMobileNumberVerified == null
          ? this.managerMobileNumberVerified
          : managerMobileNumberVerified.value,
      sendOtpResponse: sendOtpResponse == null
          ? this.sendOtpResponse
          : sendOtpResponse.value,
    );
  }

  bool isFormValid() {
    print("managerMobileNumberVerified $managerMobileNumberVerified");
    if (managerInfo == null ||
        siteLocationType == null ||
        contactInfo?.mail == null ||
        emailValidator.isNotValid ||
        managerMobileNumberVerified != true) {
      return false;
    }

    if (siteLocationType == QRSiteLocationType.INSIDE_BUILDING) {
      if ((buildingName?.isEmpty ?? true) ||
          (buildingUnit?.isEmpty ?? true) ||
          (buildingFloor?.isEmpty ?? true) ||
          (buildingDirections?.isEmpty ?? true) ||
          (selectedBuildingNature == null)) {
        return false;
      }
    }

    if (siteLocationType == QRSiteLocationType.ON_STREET) {
      if ((siteName?.isEmpty ?? true) ||
          (siteDesc?.isEmpty ?? true) ||
          (siteLandmark?.isEmpty ?? true) ||
          (selectedSiteNature == null)) {
        return false;
      }
    }

    return true;
  }

  bool get isLoading =>
      applyStatus == BlocStatus.loading ||
      buildingNatureStatus == BlocStatus.loading ||
      status == BlocStatus.loading ||
      paymentsMethodsStatus == BlocStatus.loading ||
      siteNatureStatus == BlocStatus.loading;
  bool get isFailure =>
      applyStatus == BlocStatus.failure ||
      buildingNatureStatus == BlocStatus.failure ||
      status == BlocStatus.failure ||
      paymentsMethodsStatus == BlocStatus.failure ||
      siteNatureStatus == BlocStatus.failure;
}
