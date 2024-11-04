part of 'ekram_request_transportation_bloc.dart';

class EkramRequestTransportationState extends Equatable {
  final String? errorMsg;
  final bool? isVerified;
  final List<LookUpItem>? nationalIdTypes;
  final bool isdeceasedInfoReadOnly;
  final String? deceassedDOBHijri;
  final LookUpItem? selectedNationalIdType;
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
  final String? deceassedDOBGorgian;
  final String? addTransportBurialId;
  final String? deceasedId;
  final SaveDeceasedInfoParams? saveDeceasedInfoParams;

  const EkramRequestTransportationState(
      {this.deceassedDOBGorgian,
      this.isVerified,
      this.addTransportBurialId,
      this.deceasedId,
      this.deceassedDOBHijri,
      this.isdeceasedInfoReadOnly = false,
      this.errorMsg,
      this.nationalIdTypes,
      this.selectedNationalIdType,
      this.status = BlocStatus.initial,
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
      this.saveDeceasedInfoParams,
      this.letter});

  EkramRequestTransportationState copyWith({
    final Nullable<String?>? deceassedDOBHijri,
    final bool? isdeceasedInfoReadOnly,
    final bool? isVerified,
    final BlocStatus? status,
    final String? errorMsg,
    final LookUpItem? selectedNationalIdType,
    final List<LookUpItem>? nationalIdTypes,
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
    final FileDataItem? letter,
    final Nullable<String?>? deceassedDOBGorgian,
    final String? addTransportBurialId,
    final String? deceasedId,
    final SaveDeceasedInfoParams? saveDeceasedInfoParams,
  }) {
    return EkramRequestTransportationState(
      isdeceasedInfoReadOnly:
          isdeceasedInfoReadOnly ?? this.isdeceasedInfoReadOnly,
      isVerified: isVerified ?? this.isVerified,
      errorMsg: errorMsg ?? this.errorMsg,
      selectedNationalIdType:
          selectedNationalIdType ?? this.selectedNationalIdType,
      nationalIdTypes: nationalIdTypes ?? this.nationalIdTypes,
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
      fullName: fullName ?? fullName,
      mobileNumber: mobileNumber ?? mobileNumber,
      requestType: requestType,
      addTransportBurialId: addTransportBurialId,
      deceasedId: deceasedId ?? this.deceasedId,
      deceassedDOBGorgian: deceassedDOBGorgian == null
          ? this.deceassedDOBGorgian
          : deceassedDOBGorgian.value,
      deceassedDOBHijri: deceassedDOBHijri == null
          ? this.deceassedDOBHijri
          : deceassedDOBHijri.value,
      saveDeceasedInfoParams:
          saveDeceasedInfoParams ?? this.saveDeceasedInfoParams,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isVerified,
        saveDeceasedInfoParams,
        selectedNationalIdType,
        currentPageValue,
        relation,
        deathLocation,
        selectedCity,
        selectedHospital,
        selectedNationality,
        deceasedInfoDto,
        letter,
        agreement,
        deceasedId,
        otherHospitalName,
        deceassedDOBGorgian,
        deceassedDOBHijri,
      ];

  bool isNextButtonEnabled() {
    if (currentPageValue == 0) {
      return isVerified ?? false;
    }

    if (currentPageValue == 1) {
      // if ((deceasedInfoDto?.length ?? 0) > 0)
      //   return true;
      // else
      //   return false;
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
}
