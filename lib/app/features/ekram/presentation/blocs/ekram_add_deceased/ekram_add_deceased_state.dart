// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'ekram_add_deceased_bloc.dart';

class EkramAddDeceasedState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final DeceasedInfoDto data;
  final LookUpItem? deathCity;
  final List<LookUpItem>? specialNeeds;
  final List<LookUpItem>? cities;
  final List<LookUpItem>? nationalities;
  final List<LookUpItem>? nationalTypes;
  final List<LookUpItem>? cemetries;
  final List<LookUpItem>? cemetryTypeItems;
  final List<LookUpItem>? burialTimeItems;
  final List<LookUpItem>? orgnizations;

  EkramAddDeceasedState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.deathCity,
    required this.data,
    this.specialNeeds,
    this.cities,
    this.nationalities,
    this.nationalTypes,
    this.cemetries,
    this.cemetryTypeItems,
    this.burialTimeItems,
    this.orgnizations,
  });

  bool isFormValid() {
    print(data.specialTransferNeeded);
    print(data.specialTransferOtherReason);
    print(data.specialTransferReasonId);

    if (data.isMuslim == null ||
        data.gender == null ||
        (data.burialCityId == null && data.multipleCityRequest == true) ||
        data.multipleCityRequest == null ||
        data.burialDateGorgian == null ||
        data.burialDateHijri == null ||
        data.selectedTime == null ||
        data.isPandemicDeath == null ||
        data.selectedCemetry == null ||
        data.selectedCemetryType == null ||
        data.nationalityId == null ||
        //  (data.permitNo?.isEmpty ?? true) ||
        (data.selectedOrgnization == null) ||
        data.specialTransferNeeded == null) {
      return false;
    }

    if (data.selectedTime?.id == 30976) {
      if (data.otherTimeName?.isEmpty ?? true) {
        return false;
      }
    }

    if ((data.deceassedId?.isEmpty ?? true) ||
        data.selectedNationalType == null ||
        data.deceassedDOBGorgian == null ||
        data.deceassedDOBHijri == null ||
        (data.firstName?.isEmpty ?? true) ||
        (data.fourthName?.isEmpty ?? true)) {
      return false;
    }

    if (data.specialTransferNeeded == true) {
      if (data.specialTransferReasonId?.id == 30208 &&
          (data.specialTransferOtherReason == null ||
              (data.specialTransferOtherReason != null &&
                  data.specialTransferOtherReason!.isEmpty))) {
        return false;
      } else {
        if (data.specialTransferReasonId == null) return false;
      }
    }
    if (data.multipleCityRequest == true && data.burialCityId == null)
      return false;

    return true;
  }

  @override
  List<Object?> get props {
    return [
      status,
      errorMessage,
      data,
      specialNeeds,
      cities,
      nationalities,
      nationalTypes,
      cemetries,
      cemetryTypeItems,
      burialTimeItems,
      orgnizations,
    ];
  }

  EkramAddDeceasedState copyWith({
    BlocStatus? status,
    String? errorMessage,
    DeceasedInfoDto? data,
    LookUpItem? deathCity,
    List<LookUpItem>? specialNeeds,
    List<LookUpItem>? cities,
    List<LookUpItem>? nationalities,
    List<LookUpItem>? nationalTypes,
    List<LookUpItem>? cemetries,
    List<LookUpItem>? cemetryTypeItems,
    List<LookUpItem>? burialTimeItems,
    List<LookUpItem>? orgnizations,
  }) {
    return EkramAddDeceasedState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        data: data ?? this.data,
        specialNeeds: specialNeeds ?? this.specialNeeds,
        cities: cities ?? this.cities,
        nationalities: nationalities ?? this.nationalities,
        nationalTypes: nationalTypes ?? this.nationalTypes,
        cemetries: cemetries ?? this.cemetries,
        cemetryTypeItems: cemetryTypeItems ?? this.cemetryTypeItems,
        burialTimeItems: burialTimeItems ?? this.burialTimeItems,
        orgnizations: orgnizations ?? this.orgnizations,
        deathCity: deathCity ?? this.deathCity);
  }

  List<LookUpItem>? burialCities() {
    if (data.multipleCityRequest == true) {
      return cities
          ?.where((element) => element.id != data.deathCity?.id)
          .toList();
    }
    return cities;
  }

  bool allowFillData() {
    return data?.selectedNationalType?.fillInfo == true;
  }

  bool isFormDisabled() {
    return data.graveDetails != null;
  }

  bool isCemetryDisabled() {
    return data.graveDetails?.burialInfo?.getHijriDate() != null;
  }

  bool isBurialDatesDisabled() {
    return data.graveDetails?.burialInfo?.getHijriDate() != null;
  }
}
