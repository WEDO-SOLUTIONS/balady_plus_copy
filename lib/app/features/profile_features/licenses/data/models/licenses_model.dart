import '../../licenses_exports.dart';

class LicensesModel extends LicenseEntity {
  const LicensesModel(
      {required super.licenseNumber,
      required super.licenseStatusId,
      required super.licenseStatusName,
      required super.licenseTypeName,
      required super.requestTypeName,
      required super.municipalityName,
      required super.subMunicipalityName,
      required super.licenseEndDate,
      required super.updateTime,
      super.redirectUrl,
      super.requestMainTypeId,
      super.requestNumber});

  factory LicensesModel.fromMap(Map<String, dynamic> json) {
    return LicensesModel(
        licenseNumber: int.parse(json['licenseNumber'].toString()),
        licenseStatusId: int.parse(json['licenseStatusId'].toString()),
        licenseStatusName: json['licenseStatusName'] as String,
        licenseTypeName: json['licenseName'] as String,
        requestTypeName: json['requestTypeName'] as String? ?? '',
        municipalityName: json['municipalityName'] as String,
        subMunicipalityName: json['subMunicipalityName'] as String? ?? '',
        licenseEndDate: DateTime.parse(json['licenseEndDate'] as String),
        updateTime: DateTime.tryParse(json['updateTime'] as String? ?? ''),
        redirectUrl: json["redirectUrl"],
        requestMainTypeId: json["requestMainTypeId"],
        requestNumber: json["requestNumber"]);
  }
}
