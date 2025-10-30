import '../../municipal_advisor_exports.dart';

class RequestStepModel extends RequestStepEntity {
  const RequestStepModel({
    required super.stepId,
    required super.stepName,
    required super.sequenceId,
    required super.index,
  });

  factory RequestStepModel.fromMap(Map<String, dynamic> map) {
    return RequestStepModel(
      stepId: map['stepId'] as String? ?? '',
      stepName: map['stepName'] as String? ?? '',
      sequenceId: map['sequenceId'] as int? ?? 0,
      index: map['index'] as int? ?? 0,
    );
  }
}
