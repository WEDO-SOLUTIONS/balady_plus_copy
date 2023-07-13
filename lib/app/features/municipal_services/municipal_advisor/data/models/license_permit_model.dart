import '../../municipal_advisor_exports.dart' show LicensePermitEntity;

class LicensePermitModel extends LicensePermitEntity {
  const LicensePermitModel({
    required super.id,
    required super.name,
    required super.cost,
  });

  factory LicensePermitModel.fromMap(Map<String, dynamic> map) {
    return LicensePermitModel(
      id: map['id'] as int,
      name: map['name'] as String,
      cost: map['cost'] as num,
    );
  }
}
