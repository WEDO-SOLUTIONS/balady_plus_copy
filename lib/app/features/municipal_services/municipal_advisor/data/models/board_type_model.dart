import '../../municipal_advisor_exports.dart' show BoardTypeEntity;

class BoardTypeModel extends BoardTypeEntity {
  const BoardTypeModel({
    required super.id,
    required super.name,
  });

  factory BoardTypeModel.fromMap(Map<String, dynamic> map) {
    return BoardTypeModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
