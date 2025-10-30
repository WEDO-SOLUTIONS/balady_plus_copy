import '../../violations_exports.dart' show ViolationsStatusEntity;

class ViolationsStatusModel extends ViolationsStatusEntity {
  const ViolationsStatusModel({
    required super.id,
    required super.name,
  });

  factory ViolationsStatusModel.fromMap(Map<String, dynamic> map) {
    return ViolationsStatusModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
