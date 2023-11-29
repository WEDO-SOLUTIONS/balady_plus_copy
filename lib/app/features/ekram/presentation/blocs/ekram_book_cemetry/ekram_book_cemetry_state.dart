part of 'ekram_book_cemetry_bloc.dart';

class EkramBookCemetryState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final List<LookUpItem>? nationalTypes;
  final List<LookUpItem>? cities;
  final List<LookUpItem>? cemetries;

  final List<LookUpItem>? cemetrySizeItems;
  final List<LookUpItem>? cemetryTypeItems;
  final List<LookUpItem>? burialTimeItems;

  final String? burialDateHijri;
  final String? burialDateGorgian;
  final bool? isPandemicDeath;
  final bool? isFetus;
  final bool? isMuslim;

  final bool? agreement;
  final String? fullName;
  final String? mobileNumber;
  final String? requestType;
  final String? relation;
  final LookUpItem? selectedNationalType;
  final LookUpItem? selectedCity;
  final LookUpItem? selectedCemetry;

  final LookUpItem? selectedCemetrySize;
  final LookUpItem? selectedCemetryType;
  final LookUpItem? selectedTime;
  final String? otherTimeName;

  final String? deceassedId;
  final String? deceassedDOBGorgian;
  final String? deceassedDOBHijri;
  final UserInfoResponse? userInfoResponse;
  final int? gender;

  //final LookUpItem? selectedHospital;
  // final String? otherHospitalName;
  //final LookUpItem? selectedNationality;

  EkramBookCemetryState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.selectedNationalType,
      this.nationalTypes,
      this.deceassedId,
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
      this.gender});

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
      final String? deceassedId,
      final String? deceassedDOB,
      final bool? agreement,
      final String? requestType,
      final String? relation,
      final LookUpItem? selectedNationalType,
      final LookUpItem? selectedCity,
      final LookUpItem? selectedCemetry,
      final LookUpItem? selectedCemetrySize,
      final LookUpItem? selectedCemetryType,
      final LookUpItem? selectedTime,
      final String? otherTimeName,
      final UserInfoResponse? userInfoResponse,
      final bool? clearUserInfo,
      final bool? clearOtherBurialTime,
      final String? deceassedDOBGorgian,
      final String? deceassedDOBHijri,
      final bool? isMuslim,
      final int? gender}) {
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
        deceassedId: deceassedId ?? this.deceassedId,
        deceassedDOBGorgian: deceassedDOBGorgian ?? this.deceassedDOBGorgian,
        deceassedDOBHijri: deceassedDOBHijri ?? this.deceassedDOBHijri,
        userInfoResponse: clearUserInfo == true
            ? null
            : userInfoResponse ?? this.userInfoResponse,
        nationalTypes: nationalTypes ?? this.nationalTypes,
        selectedNationalType: selectedNationalType ?? this.selectedNationalType,
        cities: cities ?? this.cities,
        cemetries: cemetries ?? this.cemetries,
        selectedCity: selectedCity ?? this.selectedCity,
        selectedCemetry: selectedCemetry ?? this.selectedCemetry,
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
        isMuslim: isMuslim ?? this.isMuslim,
        gender: gender ?? this.gender);
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
        gender
      ];

  bool isNextButtonEnabled() {
    print("isNextButtonEnabled");
    print(selectedTime);
    if (currentPageValue == 0) {
      if (relation?.isEmpty ?? true) return false;
      return true;
    } else if (currentPageValue == 1) {
      if (selectedNationalType != null &&
          userInfoResponse != null &&
          isMuslim != null &&
          isFetus != null) {
        return true;
      } else {
        return false;
      }
    } else if (currentPageValue == 2) {
      print("KK");
      if (selectedCity == null ||
          burialDateGorgian == null ||
          burialDateHijri == null ||
          selectedTime == null ||
          isPandemicDeath == null) {
        return false;
      } else {
        if (selectedTime?.id == 30976) {
          if (otherTimeName?.isEmpty ?? true)
            return false;
          else
            return true;
        } else
          return true;
      }
    } else if (currentPageValue == 3) {
      if (agreement == true &&
          selectedCemetry != null &&
          selectedCemetrySize != null &&
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
