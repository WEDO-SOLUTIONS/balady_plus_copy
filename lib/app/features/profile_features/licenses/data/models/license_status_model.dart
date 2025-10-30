import '../../licenses_exports.dart' show LicenseStatusEntity;

class LicenseStatusModel extends LicenseStatusEntity {
  const LicenseStatusModel({
    required super.id,
    required super.name,
  });

  factory LicenseStatusModel.fromMap(Map<String, dynamic> map) {
    return LicenseStatusModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
