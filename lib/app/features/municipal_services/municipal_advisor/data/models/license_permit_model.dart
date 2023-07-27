import '../../municipal_advisor_exports.dart' show LicensePermitEntity;

class LicensePermitModel extends LicensePermitEntity {
  const LicensePermitModel({
    required super.permitTypeId,
    required super.name,
    required super.cost,
    required super.calculatorServiceId,
  });

  factory LicensePermitModel.fromMap(Map<String, dynamic> map) {
    return LicensePermitModel(
      permitTypeId: map['permitTypeId'] as int? ?? 0,
      name: map['name'] as String,
      cost: map['cost'] as num? ?? 0,
      calculatorServiceId: map['calculatorServiceId'] as int? ?? 0,
    );
  }
}
