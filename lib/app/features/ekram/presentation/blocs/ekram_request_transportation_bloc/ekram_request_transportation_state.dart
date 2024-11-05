part of 'ekram_request_transportation_bloc.dart';

class EkramRequestTransportationState extends Equatable {
  final String? errorMsg;
  final bool? isVerified;
  final List<LookUpItem>? nationalIdTypes;
  final bool isdeceasedInfoReadOnly;
  final bool isBurialDatesDisabled;
  final bool isDeathDatesDisabled;
  final String? deceassedDOBHijri;
  final String? burialDateHijri;
  final LookUpItem? selectedNationalIdType;
  final LookUpItem? selectedCemetryType;
  final List<LookUpItem>? countries;
  final List<LookUpItem>? prayers;
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final List<LookUpItem>? cities;
  final List<LookUpItem>? bodyArrivalCities;
  final List<LookUpItem>? hospitals;
  final List<LookUpItem>? nationalities;
  final List<LookUpItem>? cemetryTypeItems;
  final bool? agreement;
  final String? fullName;
  final String? mobileNumber;
  final String? requestType;
  final String? relation;
  final String? deathLocation;
  final LookUpItem? selectedCity;
  final LookUpItem? selectedPrayer;
  final LookUpItem? selectedBurialCity;
  final LookUpItem? selectedBodyArrivalCity;
  final LookUpItem? selectedCountry;
  final LookUpItem? selectedHospital;
  final String? otherHospitalName;
  final LookUpItem? selectedNationality;
  final List<DeceasedInfoDto>? deceasedInfoDto;
  final FileDataItem? letter;
  final String? deceassedDOBGorgian;
  final String? burialDateGregorian;
  final String? deathDateGregorian;
  final String? deathDateHijri;
  final String? requestId;
  final String? deceasedId;
  final RequestDetailsResponseModel? requestDetailsModel;
  final bool? editInfoSection;

  const EkramRequestTransportationState(
      {this.deceassedDOBGorgian,
      this.burialDateGregorian,
      this.deathDateGregorian,
      this.deathDateHijri,
      this.isVerified,
      this.requestId,
      this.deceasedId,
      this.deceassedDOBHijri,
      this.burialDateHijri,
      this.isdeceasedInfoReadOnly = false,
      this.isBurialDatesDisabled = false,
      this.isDeathDatesDisabled = false,
      this.errorMsg,
      this.nationalIdTypes,
      this.selectedNationalIdType,
      this.selectedCemetryType,
      this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.cities,
      this.bodyArrivalCities,
      this.hospitals,
      this.countries,
      this.prayers,
      this.nationalities,
      this.cemetryTypeItems,
      this.agreement,
      this.fullName,
      this.mobileNumber,
      this.requestType,
      this.relation,
      this.deathLocation,
      this.selectedCity,
      this.selectedPrayer,
      this.selectedBurialCity,
      this.selectedBodyArrivalCity,
      this.selectedCountry,
      this.selectedHospital,
      this.otherHospitalName,
      this.selectedNationality,
      this.deceasedInfoDto,
      this.requestDetailsModel,
      this.letter,
      this.editInfoSection});

  EkramRequestTransportationState copyWith({
    final Nullable<String?>? deceassedDOBHijri,
    final Nullable<String?>? burialDateHijri,
    final bool? isdeceasedInfoReadOnly,
    final bool? isBurialDatesDisabled,
    final bool? isDeathDatesDisabled,
    final bool? isVerified,
    final BlocStatus? status,
    final String? errorMsg,
    final LookUpItem? selectedNationalIdType,
    final LookUpItem? selectedCemetryType,
    final List<LookUpItem>? nationalIdTypes,
    final String? errorMessage,
    final int? currentPageValue,
    final bool? agreement,
    final String? relation,
    final String? deathLocation,
    final List<LookUpItem>? cities,
    final List<LookUpItem>? bodyArrivalCities,
    final List<LookUpItem>? hospitals,
    final List<LookUpItem>? countries,
    final List<LookUpItem>? prayers,
    final List<LookUpItem>? nationalities,
    final List<LookUpItem>? cemetryTypeItems,
    final LookUpItem? selectedCity,
    final LookUpItem? selectedPrayer,
    final LookUpItem? selectedBurialCity,
    final LookUpItem? selectedBodyArrivalCity,
    final LookUpItem? selectedCountry,
    final LookUpItem? selectedHospital,
    final String? otherHospitalName,
    final LookUpItem? selectedNationality,
    final List<DeceasedInfoDto>? deceasedInfoDto,
    final bool? clearHospital,
    final FileDataItem? letter,
    final Nullable<String?>? deceassedDOBGorgian,
    final Nullable<String?>? burialDateGregorian,
    final Nullable<String?>? deathDateGregorian,
    final Nullable<String?>? deathDateHijri,
    final String? requestId,
    final String? deceasedId,
    final RequestDetailsResponseModel? requestDetailsModel,
    final bool? editInfoSection,
  }) {
    return EkramRequestTransportationState(
      isdeceasedInfoReadOnly:
          isdeceasedInfoReadOnly ?? this.isdeceasedInfoReadOnly,
      isBurialDatesDisabled:
          isBurialDatesDisabled ?? this.isBurialDatesDisabled,
      isDeathDatesDisabled: isDeathDatesDisabled ?? this.isDeathDatesDisabled,
      isVerified: isVerified ?? this.isVerified,
      errorMsg: errorMsg ?? this.errorMsg,
      selectedNationalIdType:
          selectedNationalIdType ?? this.selectedNationalIdType,
      selectedCemetryType: selectedCemetryType ?? this.selectedCemetryType,
      nationalIdTypes: nationalIdTypes ?? this.nationalIdTypes,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPageValue: currentPageValue ?? this.currentPageValue,
      agreement: agreement ?? this.agreement,
      relation: relation ?? this.relation,
      deathLocation: deathLocation ?? this.deathLocation,
      cities: cities ?? this.cities,
      bodyArrivalCities: bodyArrivalCities ?? this.bodyArrivalCities,
      hospitals: hospitals ?? this.hospitals,
      countries: countries ?? this.countries,
      prayers: prayers ?? this.prayers,
      nationalities: nationalities ?? this.nationalities,
      cemetryTypeItems: cemetryTypeItems ?? this.cemetryTypeItems,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedPrayer: selectedPrayer ?? this.selectedPrayer,
      selectedBurialCity: selectedBurialCity ?? this.selectedBurialCity,
      selectedBodyArrivalCity:
          selectedBodyArrivalCity ?? this.selectedBodyArrivalCity,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedHospital: clearHospital == true
          ? null
          : selectedHospital ?? this.selectedHospital,
      selectedNationality: selectedNationality ?? this.selectedNationality,
      deceasedInfoDto: deceasedInfoDto ?? this.deceasedInfoDto,
      letter: letter ?? this.letter,
      otherHospitalName: otherHospitalName ?? this.otherHospitalName,
      fullName: fullName ?? fullName,
      mobileNumber: mobileNumber ?? mobileNumber,
      requestType: requestType,
      requestId: requestId ?? this.requestId,
      deceasedId: deceasedId ?? this.deceasedId,
      deceassedDOBGorgian: deceassedDOBGorgian == null
          ? this.deceassedDOBGorgian
          : deceassedDOBGorgian.value,
      burialDateGregorian: burialDateGregorian == null
          ? this.burialDateGregorian
          : burialDateGregorian.value,
      deathDateGregorian: deathDateGregorian == null
          ? this.deathDateGregorian
          : deathDateGregorian.value,
      deathDateHijri:
          deathDateHijri == null ? this.deathDateHijri : deathDateHijri.value,
      deceassedDOBHijri: deceassedDOBHijri == null
          ? this.deceassedDOBHijri
          : deceassedDOBHijri.value,
      burialDateHijri: burialDateHijri == null
          ? this.burialDateHijri
          : burialDateHijri.value,
      requestDetailsModel: requestDetailsModel ?? this.requestDetailsModel,
      editInfoSection: editInfoSection ?? this.editInfoSection,
    );
  }

  @override
  List<Object?> get props => [
        cities,
        countries,
        prayers,
        status,
        isVerified,
        requestDetailsModel,
        selectedNationalIdType,
        selectedCemetryType,
        currentPageValue,
        relation,
        deathLocation,
        selectedCity,
        selectedPrayer,
        selectedBurialCity,
        selectedBodyArrivalCity,
        selectedCountry,
        selectedHospital,
        selectedNationality,
        deceasedInfoDto,
        letter,
        agreement,
        deceasedId,
        otherHospitalName,
        deceassedDOBGorgian,
        burialDateGregorian,
        deathDateGregorian,
        deathDateHijri,
        deceassedDOBHijri,
        burialDateHijri,
        isDeathDatesDisabled,
        isBurialDatesDisabled,
        cemetryTypeItems,
        bodyArrivalCities
      ];

  bool isNextButtonEnabled() {


    if (currentPageValue == 0) {


      return isVerified ?? false;
    }

    if (currentPageValue == 1) {
      return validateDeceasedInfoSection(false);
    } else if (currentPageValue == 2) {
      /*  if (deathLocation?.isNotEmpty ?? false) {
        return true;
      } else {
        return false;
      }*/
      return true;
    } else if (currentPageValue == 3) {
      if (agreement == null || agreement == false) return false;
    }

    return true;
  }

  LookUpItem? getNationalityById(int? id) {
    if (nationalities != null && id != null) {
      for (int index = 0; index < nationalities!.length; index++) {
        if (nationalities![index].id == id) {
          return nationalities![index];
        }
      }
    }

    return null;
  }

  bool validateDeceasedInfoSection(bool ShowErrorMessage) {
    if (requestDetailsModel != null) {
      if (requestDetailsModel?.deceasedInfo?.firstName == null ||
          requestDetailsModel!.deceasedInfo!.firstName!.isEmpty) {
        if (ShowErrorMessage == true)
          CommonFunctions.showError("lbl_first_name_hint2".tr());
        return false;
      } else if (requestDetailsModel?.deceasedInfo?.fourthName == null ||
          requestDetailsModel!.deceasedInfo!.fourthName!.isEmpty) {
        if (ShowErrorMessage == true)
          CommonFunctions.showError("enter_ekram_fourth_name".tr());
        return false;
      } else if (requestDetailsModel?.deceasedInfo?.nationalityId == null) {
        if (ShowErrorMessage == true)
          CommonFunctions.showError("enternationilaty".tr());
        return false;
      }

      return true;
    } else {
      if (ShowErrorMessage == true)
        CommonFunctions.showError("lbl_first_name_hint2".tr());
      return false;
    }
  }
}
