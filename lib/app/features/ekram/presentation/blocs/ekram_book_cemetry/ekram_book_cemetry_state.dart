part of 'ekram_book_cemetry_bloc.dart';

class EkramBookCemetryState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final List<LookUpItem>? nationalTypes;
  final List<LookUpItem>? countries;
  final List<LookUpItem>? deathCities;
  final LookUpItem? selectedCountry;
  final LookUpItem? selectedDeathCity;
  final String? otherDeathCity;

  final List<LookUpItem>? cities;
  final List<LookUpItem>? cemetries;
  final List<LookUpItem>? nationalities;

  final List<LookUpItem>? cemetrySizeItems;
  final List<LookUpItem>? cemetryTypeItems;
  final List<LookUpItem>? burialTimeItems;

  final String? burialDateHijri;
  final String? burialDateGorgian;
  final bool? isPandemicDeath;
  final bool? isFetus;
  final bool? isMuslim;
  //depend on the object coming form the backend
  final bool isMuslimEnabled;
  //depend on the object coming form the backend
  final bool isEpidamicEnabled;
  final bool isdeceasedInfoReadOnly;
  //depend on the object coming form the backend
  final bool isNationalityEnables;

  final bool? agreement;
  final String? fullName;
  final String? mobileNumber;
  final String? requestType;
  final String? relation;
  final LookUpItem? selectedNationalType;
  final LookUpItem? selectedCity;
  final LookUpItem? selectedCemetry;
  final LookUpItem? selectedNationality;

  final LookUpItem? selectedCemetrySize;
  final LookUpItem? selectedCemetryType;
  final LookUpItem? selectedTime;
  final String? otherTimeName;

  final String? deceassedId;
  final int? identityType;
  final String? deceassedDOBGorgian;
  final String? deceassedDOBHijri;
  final UserInfoResponse? userInfoResponse;
  final String? gender;
  final String? firstName;
  final String? secondName;
  final String? thirdName;
  final String? fourthName;
  final int? deathCountryId;
  final int? deathCityId;
  final DeceasedInfoModel? deceasedInfoModel;
  final DeathInfo? deathInfo;

  //final LookUpItem? selectedHospital;
  // final String? otherHospitalName;
  //final LookUpItem? selectedNationality;

  const EkramBookCemetryState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.selectedNationalType,
      this.nationalTypes,
      this.deceassedId,
      this.identityType,
      this.isFetus,
      this.deceassedDOBGorgian,
      this.deceassedDOBHijri,
      this.agreement,
      this.fullName,
      this.mobileNumber,
      this.requestType,
      this.relation,
      this.userInfoResponse,
      this.cities,
      this.cemetries,
      this.selectedCemetry,
      this.selectedCity,
      this.burialDateHijri,
      this.burialDateGorgian,
      this.burialTimeItems,
      this.cemetrySizeItems,
      this.cemetryTypeItems,
      this.isPandemicDeath,
      this.otherTimeName,
      this.selectedCemetrySize,
      this.selectedCemetryType,
      this.selectedTime,
      this.isMuslim,
      this.isMuslimEnabled = false,
      this.isEpidamicEnabled = false,
      this.isdeceasedInfoReadOnly = false,
      this.gender,
      this.firstName,
      this.secondName,
      this.thirdName,
      this.fourthName,
      this.deathCityId,
      this.deathCountryId,
      this.nationalities,
      this.selectedNationality,
      this.countries,
      this.deathCities,
      this.selectedCountry,
      this.selectedDeathCity,
      this.otherDeathCity,
      this.isNationalityEnables = true,
      this.deceasedInfoModel,
      this.deathInfo});

  EkramBookCemetryState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final int? currentPageValue,
      final List<LookUpItem>? nationalTypes,
      final List<LookUpItem>? cities,
      final List<LookUpItem>? cemetries,
      final List<LookUpItem>? cemetrySizeItems,
      final List<LookUpItem>? cemetryTypeItems,
      final List<LookUpItem>? burialTimeItems,
      final String? burialDateHijri,
      final String? burialDateGorgian,
      final bool? isPandemicDeath,
      final bool? isFetus,
      final String? deceassedDOB,
      final bool? agreement,
      final String? requestType,
      final String? relation,
      final LookUpItem? selectedNationalType,
      final LookUpItem? selectedCity,
      final Nullable<LookUpItem?>? selectedCemetry,
      final LookUpItem? selectedCemetrySize,
      final LookUpItem? selectedCemetryType,
      final LookUpItem? selectedTime,
      final String? otherTimeName,
      final bool? clearUserInfo,
      final bool? clearOtherBurialTime,
      final Nullable<String?>? deceassedId,
      final int? identityType,
      final Nullable<String?>? deceassedDOBGorgian,
      final Nullable<String?>? deceassedDOBHijri,
      final UserInfoResponse? userInfoResponse,
      final Nullable<bool?>? isMuslim,
      final bool? isdeceasedInfoReadOnly,
      final bool? isMuslimEnabled,
      final bool? isEpidamicEnabled,
      final bool? isNationalityEnables,
      final Nullable<String?>? gender,
      final Nullable<String?>? firstName,
      final Nullable<String?>? secondName,
      final Nullable<String?>? thirdName,
      final Nullable<String?>? fourthName,
      final int? deathCityId,
      final int? deathCountryId,
      final List<LookUpItem>? nationalities,
      final Nullable<LookUpItem?>? selectedNationality,
      final List<LookUpItem>? countries,
      final List<LookUpItem>? deathCities,
      final LookUpItem? selectedCountry,
      final LookUpItem? selectedDeathCity,
      final String? otherDeathCity,
      final DeceasedInfoModel? deceasedInfoModel,
      final DeathInfo? deathInfo}) {
    return EkramBookCemetryState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        agreement: agreement ?? this.agreement,
        isFetus: isFetus ?? this.isFetus,
        relation: relation ?? this.relation,
        fullName: fullName,
        mobileNumber: mobileNumber,
        requestType: requestType,
        deceassedId: deceassedId == null ? this.deceassedId : deceassedId.value,
        identityType: identityType,
        deceassedDOBGorgian: deceassedDOBGorgian == null
            ? this.deceassedDOBGorgian
            : deceassedDOBGorgian.value,
        deceassedDOBHijri: deceassedDOBHijri == null
            ? this.deceassedDOBHijri
            : deceassedDOBHijri.value,
        userInfoResponse: clearUserInfo == true
            ? null
            : userInfoResponse ?? this.userInfoResponse,
        nationalTypes: nationalTypes ?? this.nationalTypes,
        selectedNationalType: selectedNationalType ?? this.selectedNationalType,
        cities: cities ?? this.cities,
        cemetries: cemetries ?? this.cemetries,
        selectedCity: selectedCity ?? this.selectedCity,
        selectedCemetry: selectedCemetry == null
            ? this.selectedCemetry
            : selectedCemetry.value,
        selectedCemetrySize: selectedCemetrySize ?? this.selectedCemetrySize,
        selectedCemetryType: selectedCemetryType ?? this.selectedCemetryType,
        selectedTime: selectedTime ?? this.selectedTime,
        otherTimeName: clearOtherBurialTime == true
            ? null
            : otherTimeName ?? this.otherTimeName,
        cemetrySizeItems: cemetrySizeItems ?? this.cemetrySizeItems,
        cemetryTypeItems: cemetryTypeItems ?? this.cemetryTypeItems,
        burialTimeItems: burialTimeItems ?? this.burialTimeItems,
        burialDateHijri: burialDateHijri ?? this.burialDateHijri,
        burialDateGorgian: burialDateGorgian ?? this.burialDateGorgian,
        isPandemicDeath: isPandemicDeath ?? this.isPandemicDeath,
        isMuslim: isMuslim == null ? this.isMuslim : isMuslim.value,
        isMuslimEnabled: isMuslimEnabled ?? this.isMuslimEnabled,
        isEpidamicEnabled: isEpidamicEnabled ?? this.isEpidamicEnabled,
        isdeceasedInfoReadOnly:
            isdeceasedInfoReadOnly ?? this.isdeceasedInfoReadOnly,
        gender: gender == null ? this.gender : gender.value,
        firstName: firstName == null ? this.firstName : firstName.value,
        secondName: secondName == null ? this.secondName : secondName.value,
        thirdName: thirdName == null ? this.thirdName : thirdName.value,
        fourthName: fourthName == null ? this.fourthName : fourthName.value,
        deathCityId: deathCityId ?? this.deathCityId,
        deathCountryId: deathCountryId ?? this.deathCountryId,
        nationalities: nationalities ?? this.nationalities,
        selectedNationality: selectedNationality == null
            ? this.selectedNationality
            : selectedNationality.value,
        countries: countries ?? this.countries,
        deathCities: deathCities ?? this.deathCities,
        selectedCountry: selectedCountry ?? this.selectedCountry,
        selectedDeathCity: selectedDeathCity ?? this.selectedDeathCity,
        otherDeathCity: otherDeathCity ?? this.otherDeathCity,
        isNationalityEnables: isNationalityEnables ?? this.isNationalityEnables,
        deceasedInfoModel: deceasedInfoModel ?? this.deceasedInfoModel,
        deathInfo: deathInfo ?? this.deathInfo);
  }

  @override
  List<Object?> get props => [
        status,
        currentPageValue,
        relation,
        agreement,
        deceassedId,
        deceassedDOBGorgian,
        deceassedDOBHijri,
        userInfoResponse,
        selectedCemetry,
        selectedCity,
        cemetries,
        cities,
        selectedNationalType,
        cemetrySizeItems,
        cemetryTypeItems,
        burialTimeItems,
        burialDateHijri,
        isPandemicDeath,
        otherTimeName,
        selectedTime,
        selectedCemetryType,
        selectedCemetrySize,
        burialDateGorgian,
        isFetus,
        isMuslim,
        isMuslimEnabled,
        gender,
        fourthName,
        thirdName,
        secondName,
        firstName,
        deathCities,
        countries,
        selectedNationality,
        selectedCountry,
        selectedDeathCity,
        otherDeathCity,
        deceasedInfoModel,
        deathInfo
      ];

  bool allowFillData() {
    return selectedNationalType?.fillInfo == true || isFetus == true;
  }

  bool isNextButtonEnabled() {
    print("isNextButtonEnabled");
    print(selectedTime);
    if (currentPageValue == 0) {
      return true;
    } else if (currentPageValue == 1) {
      if (isMuslim == null ||
          gender == null ||
          selectedCity == null ||
          burialDateGorgian == null ||
          burialDateHijri == null ||
          selectedTime == null ||
          isPandemicDeath == null ||
          selectedCemetry == null ||
          selectedCemetryType == null ||
          selectedCountry == null ||
          selectedNationality == null ||
          firstName == null ||
          fourthName == null) {
        return false;
      }

      if (selectedTime?.id == 30976) {
        if (otherTimeName?.isEmpty ?? true) {
          return false;
        }
      }

      if (selectedCountry?.localCountry == false &&
          (otherDeathCity?.isEmpty ?? true)) return false;

      if (selectedCountry?.localCountry == true && selectedDeathCity == null) {
        return false;
      }

      if (isFetus == true) {
        if (firstName?.isEmpty ?? true) return false;
      } else if (isFetus == false) {
        if ((deceassedId?.isEmpty ?? true) ||
            selectedNationalType == null ||
            deceassedDOBGorgian == null ||
            deceassedDOBHijri == null ||
            (firstName?.isEmpty ?? true) ||
            (fourthName?.isEmpty ?? true)) {
          return false;
        }
      }

      return true;
    } else if (currentPageValue == 2) {
      if (agreement == true &&
          /* selectedCemetry != null &&*/
          selectedCemetryType != null) return true;
      return false;
    }

    return true;
  }

  bool showReligion() {
    return userInfoResponse != null &&
        userInfoResponse?.firstName != null &&
        userInfoResponse?.religionCode == null;
  }
}
