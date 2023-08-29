import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';

class ViolationState extends Equatable {
  final BlocStatus status;
  final double currentStep;
  final int selectedIndex;
  final String? errorMessage;

  const ViolationState({
    this.status = BlocStatus.initial,
    required this.selectedIndex,
    this.errorMessage,
    required this.currentStep,
  });

  ViolationState copyWith({
    final BlocStatus? status,
    final int? selectedIndex,
    final String? errorMessage,
    final double? currentStep,
  }) {
    return ViolationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
        selectedIndex,
        currentStep,
      ];
}
