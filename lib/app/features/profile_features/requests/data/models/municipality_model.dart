import '../../requests_exports.dart' show MunicipalityEntity;

class MunicipalityModel extends MunicipalityEntity {
  const MunicipalityModel({
    required super.id,
    required super.municipalId,
    required super.name,
  });

  factory MunicipalityModel.fromMap(Map<String, dynamic> json) {
    return MunicipalityModel(
      id: json['id'] as String,
      municipalId: json['amanaId'] as String,
      name: json['name'] as String,
    );
  }
}
