import '../../licenses_exports.dart' show LicenseTypeEntity;

class LicenseTypeModel extends LicenseTypeEntity {
  const LicenseTypeModel({
    required super.id,
    required super.name,
  });

  factory LicenseTypeModel.fromMap(Map<String, dynamic> map) {
    return LicenseTypeModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
