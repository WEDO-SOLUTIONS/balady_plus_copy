part of 'cr_step12_sadad_cubit.dart';

class Step4SadadState extends Equatable {
  final BlocStatus status;
  final String errorMessage;
  final CalculateFeesResponseModel? crCalculateFeesResponse;
  final List<String>? period;
  final String? selectedPeriod;

  const Step4SadadState(
      {this.status = BlocStatus.initial,
      this.errorMessage = '',
      this.period,
      this.selectedPeriod,
      this.crCalculateFeesResponse});

  @override
  List<Object?> get props =>
      [errorMessage, status, crCalculateFeesResponse, selectedPeriod];

  Step4SadadState copyWith(
      {BlocStatus? status,
      String? errorMessage,
        CalculateFeesResponseModel? crCalculateFeesResponse,
      List<String>? period,
      final String? selectedPeriod}) {
    return Step4SadadState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        period: period ?? this.period,
        selectedPeriod: selectedPeriod ?? this.selectedPeriod,
        crCalculateFeesResponse:
            crCalculateFeesResponse ?? this.crCalculateFeesResponse);
  }
}
