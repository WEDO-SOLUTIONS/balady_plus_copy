part of 'ekram_add_deceased_bloc.dart';

class EkramAddDeceasedState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final DeceasedInfoDto data;
  final List<LookUpItem>? specialNeeds;
  final List<LookUpItem>? cities;
  final List<LookUpItem>? nationalities;

  const EkramAddDeceasedState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    required this.data,
    this.specialNeeds,
    this.cities,
    this.nationalities,
  });
  EkramAddDeceasedState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final DeceasedInfoDto? data,
      final List<LookUpItem>? specialNeeds,
      final List<LookUpItem>? cities,
      final List<LookUpItem>? nationalities}) {
    return EkramAddDeceasedState(
        data: data ?? this.data,
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
        specialNeeds: specialNeeds ?? this.specialNeeds,
        cities: cities ?? this.cities,
        nationalities: nationalities ?? this.nationalities);
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, data, specialNeeds, cities, nationalities];

  bool isFormValid() {
    print(data.specialTransferNeeded);
    print(data.specialTransferOtherReason);
    print(data.specialTransferReasonId);
    if ((data.name != null &&
            data.name!.isNotEmpty &&
            ((data.name?.split(" ").length ?? 0) >= 3)) &&
        data.genderId != null &&
        data.muslimReligion != null &&
        data.multipleCityRequest != null &&
        data.nationalityId != null &&
        data.specialTransferNeeded != null) {
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

    return false;
  }
}
