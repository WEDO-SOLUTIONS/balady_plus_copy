part of 'ekram_request_transportation_bloc.dart';

class EkramRequestTransportationState extends Equatable {
  final String? errorMsg;
  final bool? isVerified;
  final bool? isSpecialTransferNeeded;
  final bool? isBurialInsideDeathCity;
  final List<LookUpItem>? nationalIdTypes;
  final bool isdeceasedInfoReadOnly;
  final bool isBurialDatesDisabled;
  final bool isDeathDatesDisabled;
  final String? deceassedDOBHijri;
  final String? burialDateHijri;
  final LookUpItem? selectedNationalIdType;
  final LookUpItem? selectedCemetryType;
  final LookUpItem? selectedlaundry;
  final LookUpItem? selectedMosque;
  final List<LookUpItem>? countries;
  final List<LookUpItem>? cemetries;
  final List<LookUpItem>? prayers;
  final List<LookUpItem>? specialTransportReasons;
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final List<LookUpItem>? cities;
  final List<LookUpItem>? bodyArrivalCities;
  final List<LookUpItem>? hospitals;
  final List<LookUpItem>? nationalities;
  final List<LookUpItem>? cemetryTypeItems;
  final List<LookUpItem>? laundries;
  final List<LookUpItem>? mosques;
  final List<LookUpItem>? transportations;
  final bool? agreement;
  final String? fullName;
  final String? mobileNumber;
  final String? requestType;
  final String? relation;
  final String? deathLocation;
  final LookUpItem? selectedDeathCity;
  final LookUpItem? selectedtransportation;
  final LookUpItem? selectedCemetry;
  final LookUpItem? selectedPrayer;
  final LookUpItem? selectedSpecialTransportReason;
  final LookUpItem? selectedBurialCity;
  final LookUpItem? selectedBodyArrivalCity;
  final LookUpItem? selectedDeathCountry;
  final LookUpItem? selectedHospital;
  final String? otherHospitalName;
  final LookUpItem? selectedNationality;
  // final List<DeceasedInfoDto>? deceasedInfoDto;
  final FileDataItem? letter;
  final String? deceassedDOBGorgian;
  final String? burialDateGregorian;
  final String? madinahEmirateApprovalStatus;
  final String? madinahEmirateApprovalDate;
  final String? deathDateGregorian;
  final String? deathDateHijri;
  final int? requestId;
  final String? deceasedId;
  final RequestDetailsResponseModel? requestDetailsModel;
  final bool? editInfoSection;

  const EkramRequestTransportationState(
      {this.deceassedDOBGorgian,
      this.burialDateGregorian,
      this.madinahEmirateApprovalStatus,
      this.madinahEmirateApprovalDate,
      this.deathDateGregorian,
      this.deathDateHijri,
      this.isVerified,
      this.isSpecialTransferNeeded,
      this.isBurialInsideDeathCity,
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
      this.selectedlaundry,
      this.selectedMosque,
      this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.cities,
      this.bodyArrivalCities,
      this.hospitals,
      this.countries,
      this.cemetries,
      this.prayers,
      this.specialTransportReasons,
      this.nationalities,
      this.cemetryTypeItems,
      this.laundries,
      this.mosques,
      this.transportations,
      this.agreement,
      this.fullName,
      this.mobileNumber,
      this.requestType,
      this.relation,
      this.deathLocation,
      this.selectedDeathCity,
      this.selectedtransportation,
      this.selectedCemetry,
      this.selectedPrayer,
      this.selectedSpecialTransportReason,
      this.selectedBurialCity,
      this.selectedBodyArrivalCity,
      this.selectedDeathCountry,
      this.selectedHospital,
      this.otherHospitalName,
      this.selectedNationality,
      // this.deceasedInfoDto,
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
    final bool? isSpecialTransferNeeded,
    final bool? isBurialInsideDeathCity,
    final BlocStatus? status,
    final String? errorMsg,
    final LookUpItem? selectedNationalIdType,
    final LookUpItem? selectedCemetryType,
    final LookUpItem? selectedlaundry,
    final LookUpItem? selectedMosque,
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
    final List<LookUpItem>? cemetries,
    final List<LookUpItem>? prayers,
    final List<LookUpItem>? specialTransportReasons,
    final List<LookUpItem>? nationalities,
    final List<LookUpItem>? cemetryTypeItems,
    final List<LookUpItem>? laundries,
    final List<LookUpItem>? mosques,
    final List<LookUpItem>? transportations,
    final LookUpItem? selectedDeathCity,
    final LookUpItem? selectedtransportation,
    final LookUpItem? selectedCemetry,
    final LookUpItem? selectedPrayer,
    final LookUpItem? selectedSpecialTransportReason,
    final LookUpItem? selectedBurialCity,
    final LookUpItem? selectedBodyArrivalCity,
    final LookUpItem? selectedDeathCountry,
    final LookUpItem? selectedHospital,
    final String? otherHospitalName,
    final LookUpItem? selectedNationality,
    // final List<DeceasedInfoDto>? deceasedInfoDto,
    final bool? clearHospital,
    final FileDataItem? letter,
    final Nullable<String?>? deceassedDOBGorgian,
    final Nullable<String?>? burialDateGregorian,
    final String? madinahEmirateApprovalStatus,
    final String? madinahEmirateApprovalDate,
    final Nullable<String?>? deathDateGregorian,
    final Nullable<String?>? deathDateHijri,
    final int? requestId,
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
      isSpecialTransferNeeded:
          isSpecialTransferNeeded ?? this.isSpecialTransferNeeded,
      isBurialInsideDeathCity:
          isBurialInsideDeathCity ?? this.isBurialInsideDeathCity,
      errorMsg: errorMsg ?? this.errorMsg,
      selectedNationalIdType:
          selectedNationalIdType ?? this.selectedNationalIdType,
      selectedCemetryType: selectedCemetryType ?? this.selectedCemetryType,
      selectedlaundry: selectedlaundry ?? this.selectedlaundry,
      selectedMosque: selectedMosque ?? this.selectedMosque,
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
      cemetries: cemetries ?? this.cemetries,
      prayers: prayers ?? this.prayers,
      specialTransportReasons:
          specialTransportReasons ?? this.specialTransportReasons,
      nationalities: nationalities ?? this.nationalities,
      cemetryTypeItems: cemetryTypeItems ?? this.cemetryTypeItems,
      laundries: laundries ?? this.laundries,
      mosques: mosques ?? this.mosques,
      transportations: transportations ?? this.transportations,
      selectedDeathCity: selectedDeathCity ?? this.selectedDeathCity,
      selectedtransportation:
          selectedtransportation ?? this.selectedtransportation,
      selectedCemetry: selectedCemetry ?? this.selectedCemetry,
      selectedPrayer: selectedPrayer ?? this.selectedPrayer,
      selectedSpecialTransportReason:
          selectedSpecialTransportReason ?? this.selectedSpecialTransportReason,
      selectedBurialCity: selectedBurialCity ?? this.selectedBurialCity,
      selectedBodyArrivalCity:
          selectedBodyArrivalCity ?? this.selectedBodyArrivalCity,
      selectedDeathCountry: selectedDeathCountry ?? this.selectedDeathCountry,
      selectedHospital: clearHospital == true
          ? null
          : selectedHospital ?? this.selectedHospital,
      selectedNationality: selectedNationality ?? this.selectedNationality,
      // deceasedInfoDto: deceasedInfoDto ?? this.deceasedInfoDto,
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
      madinahEmirateApprovalStatus: madinahEmirateApprovalStatus ?? this.madinahEmirateApprovalStatus,
      madinahEmirateApprovalDate: madinahEmirateApprovalDate ?? this.madinahEmirateApprovalDate,
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
        cemetries,
        prayers,
        specialTransportReasons,
        status,
        isVerified,
        isSpecialTransferNeeded,
        isBurialInsideDeathCity,
        requestDetailsModel,
        selectedNationalIdType,
        selectedCemetryType,
        selectedlaundry,
        selectedMosque,
        currentPageValue,
        relation,
        deathLocation,
        selectedDeathCity,
        selectedtransportation,
        selectedCemetry,
        selectedPrayer,
        selectedSpecialTransportReason,
        selectedBurialCity,
        selectedBodyArrivalCity,
        selectedDeathCountry,
        selectedHospital,
        selectedNationality,
        // deceasedInfoDto,
        letter,
        agreement,
        deceasedId,
        otherHospitalName,
        deceassedDOBGorgian,
        burialDateGregorian,
        madinahEmirateApprovalStatus,
        madinahEmirateApprovalDate,
        deathDateGregorian,
        deathDateHijri,
        deceassedDOBHijri,
        burialDateHijri,
        isDeathDatesDisabled,
        isBurialDatesDisabled,
        cemetryTypeItems,
        laundries,
        mosques,
        transportations,
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






  LookUpItem? getCityById(int? id) {

    if (cities != null && id != null) {
      for (int index = 0; index < cities!.length; index++) {
        if (cities![index].id == id) {
          return cities![index];
        }
      }
    }

    return null;
  }

  LookUpItem? getHosptialById(int? id) {

    if (hospitals != null && id != null) {
      for (int index = 0; index < hospitals!.length; index++) {
        if (hospitals![index].id == id) {
          return hospitals![index];
        }
      }
    }

    return null;
  }



  LookUpItem? getCountryById(int? id) {
    id ??= 1;
    if (countries != null) {
      for (int index = 0; index < countries!.length; index++) {
        if (countries![index].id == id) {
          return countries![index];
        }
      }
    }

    return null;
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
