import '../../municipal_advisor_exports.dart' show IsicActivityEntity;

class IsicActivityModel extends IsicActivityEntity {
  const IsicActivityModel({
    required super.id,
    required super.name,
  });

  factory IsicActivityModel.fromMap(Map<String, dynamic> map) {
    return IsicActivityModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
