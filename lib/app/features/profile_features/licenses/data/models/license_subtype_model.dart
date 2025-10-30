import '../../licenses_exports.dart' show LicenseSubTypeEntity;

class LicenseSubTypeModel extends LicenseSubTypeEntity {
  const LicenseSubTypeModel({
    required super.id,
    required super.name,
  });

  factory LicenseSubTypeModel.fromMap(Map<String, dynamic> map) {
    return LicenseSubTypeModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
