import '../../municipal_advisor_exports.dart';

class FastflowConditionModel extends FastflowConditionEntity {
  const FastflowConditionModel({
    required super.conditionName,
    required super.isRequired,
  });

  factory FastflowConditionModel.fromMap(Map<String, dynamic> map) {
    return FastflowConditionModel(
      conditionName: map['conditionName'] as String,
      isRequired: map['required'] as bool,
    );
  }
}
