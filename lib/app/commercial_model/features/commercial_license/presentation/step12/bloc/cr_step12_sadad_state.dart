part of 'cr_step12_sadad_cubit.dart';

class CrStep12SadadState extends Equatable {
  final BlocStatus status;
  final String errorMessage;
  final CrCalculateFeesResponse? crCalculateFeesResponse;
  final List<String>? period;
  final String? selectedPeriod;

  const CrStep12SadadState(
      {this.status = BlocStatus.initial,
      this.errorMessage = '',
      this.period,
      this.selectedPeriod,
      this.crCalculateFeesResponse});

  @override
  List<Object?> get props =>
      [errorMessage, status, crCalculateFeesResponse, selectedPeriod];

  CrStep12SadadState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      CrCalculateFeesResponse? crCalculateFeesResponse,
      List<String>? period,
      final String? selectedPeriod}) {
    return CrStep12SadadState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        period: period ?? this.period,
        selectedPeriod: selectedPeriod ?? this.selectedPeriod,
        crCalculateFeesResponse:
            crCalculateFeesResponse ?? this.crCalculateFeesResponse);
  }
}
