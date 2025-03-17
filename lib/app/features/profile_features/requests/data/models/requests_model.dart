import '../../requests_exports.dart';

class RequestsModel extends RequestEntity {
  const RequestsModel(
      {required super.requestNumber,
      required super.requestNumberAsText,
      required super.requestStatusId,
      required super.requestStatusName,
      required super.requestTypeName,
      required super.licenseTypeName,
      required super.municipalityName,
      required super.subMunicipalityName,
      required super.creationDate,
      required super.lastUpdateDate,
      super.redirectUrl,
      super.requestTypeId,
      super.requestMainTypeId,
      super.serviceTypeId,
      super.hashingRequestNumber});

  factory RequestsModel.fromMap(Map<String, dynamic> json) {
    return RequestsModel(
        requestNumber: json['requestNumber'] as int,
        requestNumberAsText: json['requestNumberAsText']?.toString() ?? '',
        requestStatusId: json['requestStatusId'] as int,
        requestStatusName: json['dashboardStatusName'] as String,
        requestTypeName: json['requestTypeName'] as String,
        licenseTypeName: json['licenseTypeName'] as String? ?? '',
        municipalityName: json['municipalityName'] as String? ?? '',
        subMunicipalityName: json['subMunicipalityName'] as String? ?? '',
        creationDate: DateTime.parse(json['creationDate'] as String),
        lastUpdateDate: DateTime.parse(json['updateTime'] as String),
        redirectUrl: json['redirectUrl'] as String?,
        requestTypeId: json['requestTypeId'],
        requestMainTypeId: json["requestMainTypeId"],
        hashingRequestNumber: json["hashingRequestNumber"],
        serviceTypeId: json["serviceTypeId"]);
  }
}
