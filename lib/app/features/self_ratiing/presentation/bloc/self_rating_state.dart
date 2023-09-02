import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';

class SelfRatingState extends Equatable {
  final BlocStatus status;
  final double currentStep;
  final String? errorMessage;
  final int radioSelect;

  const SelfRatingState({
    this.status = BlocStatus.initial,
    required this.currentStep,
    this.errorMessage,
    required this.radioSelect,
  });

  SelfRatingState copyWith({
    final BlocStatus? status,
    final double? currentStep,
    final String? errorMessage,
    final int? radioSelect,
  }) {
    return SelfRatingState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      radioSelect: radioSelect ?? this.radioSelect,
    );
  }

  @override
  List<Object> get props => [
        status,
        currentStep,
        radioSelect,
      ];
}
