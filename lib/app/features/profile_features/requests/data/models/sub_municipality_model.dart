import '../../requests_exports.dart' show SubMunicipalityEntity;

class SubMunicipalityModel extends SubMunicipalityEntity {
  const SubMunicipalityModel({
    required super.id,
    required super.name,
  });

  factory SubMunicipalityModel.fromMap(Map<String, dynamic> map) {
    return SubMunicipalityModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
