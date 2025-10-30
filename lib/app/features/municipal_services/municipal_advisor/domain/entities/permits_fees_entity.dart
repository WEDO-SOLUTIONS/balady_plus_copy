import 'package:equatable/equatable.dart';

import '../../municipal_advisor_exports.dart' show CalculatedFeesEntity;

class PermitsFeesEntity extends Equatable {
  final int actionTypeId;
  final String actionTypeName;
  final CalculatedFeesEntity calculatedFees;

  const PermitsFeesEntity({
    required this.actionTypeId,
    required this.actionTypeName,
    required this.calculatedFees,
  });

  @override
  List<Object?> get props => [
        actionTypeId,
        actionTypeName,
        calculatedFees,
      ];
}
