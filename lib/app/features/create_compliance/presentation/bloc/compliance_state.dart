import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';

class ComplianceState extends Equatable {
  final BlocStatus status;
  final double currentStep;
  final int radioSelect;
  const ComplianceState({
    required this.currentStep,
    this.status = BlocStatus.initial,
    required this.radioSelect,
  });
  ComplianceState copyWith({
    final BlocStatus? status,
    final double? currentStep,
    final int? radioSelect,
  }) {
    return ComplianceState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
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
