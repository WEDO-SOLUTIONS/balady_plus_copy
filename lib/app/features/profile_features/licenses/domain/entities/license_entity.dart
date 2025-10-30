import 'package:equatable/equatable.dart';

class LicenseEntity extends Equatable {
  final int licenseNumber;
  final int licenseStatusId;
  final String licenseStatusName;
  final String licenseTypeName;
  final String requestTypeName;
  final String municipalityName;
  final String subMunicipalityName;
  final DateTime licenseEndDate;
  final DateTime? updateTime;
  final String? redirectUrl;
  final String? requestMainTypeId;
  final int? requestNumber;

  const LicenseEntity(
      {required this.licenseNumber,
      required this.licenseStatusId,
      required this.licenseStatusName,
      required this.licenseTypeName,
      required this.requestTypeName,
      required this.municipalityName,
      required this.subMunicipalityName,
      required this.licenseEndDate,
      required this.updateTime,
      this.redirectUrl,
      this.requestMainTypeId,
      this.requestNumber});

  @override
  List<Object?> get props => [
        licenseNumber,
        licenseStatusId,
        licenseStatusName,
        licenseTypeName,
        requestTypeName,
        municipalityName,
        subMunicipalityName,
        licenseEndDate,
        updateTime,
        redirectUrl,
        requestMainTypeId,
        requestNumber
      ];
}
