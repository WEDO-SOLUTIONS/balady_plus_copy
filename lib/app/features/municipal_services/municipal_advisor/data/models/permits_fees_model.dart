import '../../municipal_advisor_exports.dart'
    show CalculatedFeesModel, PermitsFeesEntity;

class PermitsFeesModel extends PermitsFeesEntity {
  const PermitsFeesModel({
    required super.actionTypeId,
    required super.actionTypeName,
    required super.calculatedFees,
  });

  factory PermitsFeesModel.fromMap(Map<String, dynamic> map) {
    return PermitsFeesModel(
      actionTypeId: map['actionTypeId'] as int,
      actionTypeName: map['actionTypeName'] as String,
      calculatedFees: CalculatedFeesModel.fromMap(
          map['calculatedFees'] as Map<String, dynamic>),
    );
  }
}
