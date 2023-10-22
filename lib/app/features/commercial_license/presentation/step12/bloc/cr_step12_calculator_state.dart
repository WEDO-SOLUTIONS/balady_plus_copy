part of 'cr_step12_caculator_cubit.dart';

class CrStep12CalculatorState extends Equatable {
  final BlocStatus status;
  final String errorMessage;

  const CrStep12CalculatorState({
    this.status = BlocStatus.initial,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [errorMessage, status, status];

  CrStep12CalculatorState copyWith({
    BlocStatus? status,
    String? errorMessage,
  }) {
    return CrStep12CalculatorState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
