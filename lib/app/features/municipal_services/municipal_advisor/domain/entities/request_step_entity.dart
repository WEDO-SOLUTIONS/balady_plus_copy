import 'package:equatable/equatable.dart';

class RequestStepEntity extends Equatable {
  final String stepId;
  final String stepName;
  final int sequenceId;
  final int index;

  const RequestStepEntity({
    required this.stepId,
    required this.stepName,
    required this.sequenceId,
    required this.index,
  });

  @override
  List<Object?> get props => [
        stepId,
        stepName,
        sequenceId,
        index,
      ];
}
