import '../../municipal_advisor_exports.dart' show AccommodationTypeEntity;

class AccommodationTypeModel extends AccommodationTypeEntity {
  const AccommodationTypeModel({
    required super.id,
    required super.name,
  });

  factory AccommodationTypeModel.fromMap(Map<String, dynamic> map) {
    return AccommodationTypeModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
