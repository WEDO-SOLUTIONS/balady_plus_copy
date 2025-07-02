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
      licenseNumber: _parseInt(json['licenseNumber']),
      licenseStatusId: _parseInt(json['licenseStatusId']),
      licenseStatusName: json['licenseStatusName']?.toString() ?? '',
      licenseTypeName: json['licenseName']?.toString() ?? '',
      requestTypeName: json['requestTypeName']?.toString() ?? '',
      municipalityName: json['municipalityName']?.toString() ?? '',
      subMunicipalityName: json['subMunicipalityName']?.toString() ?? '',
      licenseEndDate: _parseDate(json['licenseEndDate']),
      updateTime: _tryParseDate(json['updateTime']),
      redirectUrl: json["redirectUrl"],
      requestMainTypeId: json["requestMainTypeId"],
      requestNumber: json["requestNumber"],
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime(1970, 1, 1);
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString()) ?? DateTime(1970, 1, 1);
  }

  static DateTime? _tryParseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
