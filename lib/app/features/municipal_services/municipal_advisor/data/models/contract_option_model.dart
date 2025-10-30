import '../../municipal_advisor_exports.dart';

class ContractOptionModel extends ContractOptionEntity {
  const ContractOptionModel({
    required super.id,
    required super.name,
  });

  factory ContractOptionModel.fromMap(Map<String, dynamic> map) {
    return ContractOptionModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
