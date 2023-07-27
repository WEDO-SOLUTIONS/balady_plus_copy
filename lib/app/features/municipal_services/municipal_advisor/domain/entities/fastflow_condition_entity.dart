import 'package:equatable/equatable.dart';

class FastflowConditionEntity extends Equatable {
  final String conditionName;
  final bool isRequired;

  const FastflowConditionEntity({
    required this.conditionName,
    required this.isRequired,
  });

  @override
  List<Object?> get props => [
        conditionName,
        isRequired,
      ];
}
