part of 'calculator_bloc.dart';

class CalculatorState extends Equatable {
  final LookUpItem? selectedPeriod;
  final String? totalArea;
  final List<AddetionalActivityItem>? addetionalActivitesResponse;
  final BlocStatus status;
  final LookUpItem? cleanOption;
  final List<PermitItem>? permits;
  final List<LookUpItem>? boards;
  final String? errorMessage;
  final String? unitCount;
  final LookUpItem? acomodationType;

  // Constructor
  const CalculatorState(
      {this.selectedPeriod,
      this.totalArea,
      this.addetionalActivitesResponse,
      this.status = BlocStatus.initial,
      this.cleanOption,
      this.permits,
      this.boards,
      this.errorMessage,
      this.unitCount,
      this.acomodationType});

  // CopyWith Method
  CalculatorState copyWith(
      {LookUpItem? selectedPeriod,
      String? totalArea,
      List<AddetionalActivityItem>? addetionalActivitesResponse,
      BlocStatus? status,
      LookUpItem? cleanOption,
      List<PermitItem>? permits,
      List<LookUpItem>? boards,
      String? unitCount,
      String? errorMessage,
      LookUpItem? acomodationType}) {
    return CalculatorState(
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      totalArea: totalArea ?? this.totalArea,
      addetionalActivitesResponse:
          addetionalActivitesResponse ?? this.addetionalActivitesResponse,
      status: status ?? this.status,
      cleanOption: cleanOption ?? this.cleanOption,
      permits: permits ?? this.permits,
      boards: boards ?? this.boards,
      errorMessage: errorMessage ?? this.errorMessage,
      unitCount: unitCount ?? this.unitCount,
      acomodationType: acomodationType ?? this.acomodationType,
    );
  }

  @override
  List<Object?> get props => [
        acomodationType,
        unitCount,
        selectedPeriod,
        totalArea,
        addetionalActivitesResponse,
        status,
        cleanOption,
        permits,
        boards,
        errorMessage,
      ];

  double getTotalArea() {
    print("GFDDDDD ${totalArea}");
    return (addetionalActivitesResponse?.isEmpty ?? true)
        ? (double.tryParse(totalArea ?? "") ?? 0)
        : (double.tryParse(totalArea ?? "") ?? 0) -
            (addetionalActivitesResponse
                    ?.map((e) =>
                        (e.area ?? 0).toDouble()) // Convert each area to double
                    .reduce((value, element) => value + element) ??
                0);
  }
}
