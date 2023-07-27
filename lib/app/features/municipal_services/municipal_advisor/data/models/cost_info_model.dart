import '../../municipal_advisor_exports.dart' show CostInfoEntity;

class CostInfoModel extends CostInfoEntity {
  const CostInfoModel({
    required super.costItemDescription,
    required super.costItemTypeId,
    required super.costItemValue,
    required super.serviceTypeId,
  });

  factory CostInfoModel.fromMap(Map<String, dynamic> map) {
    return CostInfoModel(
      costItemDescription: map['CostItemDescription'] as String,
      costItemTypeId: map['CostItemTypeId'] as int,
      costItemValue: map['CostItemValue'] as num,
      serviceTypeId: map['ServiceTypeId'] as int?,
    );
  }
}
