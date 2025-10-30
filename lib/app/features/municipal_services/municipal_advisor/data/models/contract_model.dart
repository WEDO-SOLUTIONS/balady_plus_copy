import '../../municipal_advisor_exports.dart';

class ContractModel extends ContractEntity {
  const ContractModel({
    required super.contractTypeId,
    required super.contractTypeName,
    required super.contractOptions,
  });

  factory ContractModel.fromMap(Map<String, dynamic> map) {
    return ContractModel(
      contractTypeId: map['contractTypeId'] as String,
      contractTypeName: map['contractTypeName'] as String,
      contractOptions: (map['contractOptions'] as List<dynamic>)
          .map((e) => ContractOptionModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
