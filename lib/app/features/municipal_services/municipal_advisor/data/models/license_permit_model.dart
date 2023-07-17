import '../../municipal_advisor_exports.dart' show LicensePermitEntity;

class LicensePermitModel extends LicensePermitEntity {
  const LicensePermitModel({
    required super.name,
    required super.cost,
  });

  factory LicensePermitModel.fromMap(Map<String, dynamic> map) {
    return LicensePermitModel(
      name: map['name'] as String,
      cost: map['cost'] as num? ?? 0,
    );
  }
}
