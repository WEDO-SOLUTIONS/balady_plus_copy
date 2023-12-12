part of 'ekram_request_transportation_bloc.dart';

class EkramRequestTransportationState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final List<LookUpItem>? cities;
  final List<LookUpItem>? hospitals;
  final List<LookUpItem>? nationalities;
  final bool? agreement;
  final String? fullName;
  final String? mobileNumber;
  final String? requestType;
  final String? relation;
  final String? deathLocation;
  final LookUpItem? selectedCity;
  final LookUpItem? selectedHospital;
  final String? otherHospitalName;
  final LookUpItem? selectedNationality;
  final List<DeceasedInfoDto>? deceasedInfoDto;
  final FileDataItem? letter;

  EkramRequestTransportationState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.cities,
      this.hospitals,
      this.nationalities,
      this.agreement,
      this.fullName,
      this.mobileNumber,
      this.requestType,
      this.relation,
      this.deathLocation,
      this.selectedCity,
      this.selectedHospital,
      this.otherHospitalName,
      this.selectedNationality,
      this.deceasedInfoDto,
      this.letter});

  EkramRequestTransportationState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final int? currentPageValue,
      final bool? agreement,
      final String? relation,
      final String? deathLocation,
      final List<LookUpItem>? cities,
      final List<LookUpItem>? hospitals,
      final List<LookUpItem>? nationalities,
      final LookUpItem? selectedCity,
      final LookUpItem? selectedHospital,
      final String? otherHospitalName,
      final LookUpItem? selectedNationality,
      final List<DeceasedInfoDto>? deceasedInfoDto,
      final bool? clearHospital,
      final FileDataItem? letter}) {
    return EkramRequestTransportationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPageValue: currentPageValue ?? this.currentPageValue,
      agreement: agreement ?? this.agreement,
      relation: relation ?? this.relation,
      deathLocation: deathLocation ?? this.deathLocation,
      cities: cities ?? this.cities,
      hospitals: hospitals ?? this.hospitals,
      nationalities: nationalities ?? this.nationalities,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedHospital: clearHospital == true
          ? null
          : selectedHospital ?? this.selectedHospital,
      selectedNationality: selectedNationality ?? this.selectedNationality,
      deceasedInfoDto: deceasedInfoDto ?? this.deceasedInfoDto,
      letter: letter ?? this.letter,
      otherHospitalName: otherHospitalName ?? this.otherHospitalName,
      fullName: fullName,
      mobileNumber: mobileNumber,
      requestType: requestType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentPageValue,
        relation,
        deathLocation,
        selectedCity,
        selectedHospital,
        selectedNationality,
        deceasedInfoDto,
        letter,
        agreement,
        otherHospitalName
      ];

  bool isNextButtonEnabled() {
    if (currentPageValue == 0) {
      if (selectedCity == null || selectedHospital == null) return false;

      if (selectedHospital?.id == -1 && (otherHospitalName?.isEmpty ?? true)) {
        return false;
      }
    }

    if (currentPageValue == 1) {
      if ((deceasedInfoDto?.length ?? 0) > 0)
        return true;
      else
        return false;
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
}
